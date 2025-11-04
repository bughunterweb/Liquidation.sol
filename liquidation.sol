// warning :-->  this test will not catch the bug where  colleteral and loan amount is close like  123 loan and 125 collateral since these will be bypassed by echidna
// that's why I have put the require statement which will catch this bug in real contracts.

pragma solidity ^0.8.0;


contract liquidation {

  uint256 public diff;


  /*

  earnPercent - how much liquidator get's in return like 1.04 represents 104% percent of what they provide.
  ltv --> loan to collateral value. ex -> 0.8 ether means 80%
  both above are 18 scaled.

  */


  function liq(uint256 loan, uint256 colleteral,uint256 checkers,uint256 ltvs) public {

    require(loan>1e6 && loan<colleteral);
    require(checkers>1e18 && checkers<10e18);
    require(ltvs>50e16 && ltvs<98e16);
    

  (uint256 newLoanAmount , uint256 newcollateralAmount) = liquidate(loan, colleteral,checkers,ltvs);



    }


 function liquidate(uint256 loanAmount , uint256 collateralAmount,uint256 earnPercent, uint256 ltv) internal returns (uint256 newLoanAmount , uint256 newcollateralAmount) {

 // reducing calculation error
  loanAmount *=1e10;
  collateralAmount *=1e10;

  uint256 check  = loanAmount*1e18 / collateralAmount;
  
// i think an upper bound is also needed.
  require(check > ltv); 
   

  uint256 helperA = loanAmount -((ltv * collateralAmount) /1e18);
   

  uint256 helperB =  1e18 - (earnPercent * ltv / 1e18);

  uint256 liquidatorGive = helperA*1e18 / helperB;

  uint256 liquidatorGets = liquidatorGive *earnPercent /1e18;

  
   // here in contract we won't use this requires statement , we want echidna to bypass this
  require(liquidatorGets <= collateralAmount);  

  newLoanAmount = loanAmount - liquidatorGive;
  
  newcollateralAmount = collateralAmount - liquidatorGets;
 

  // newloanAmount * 1.25 = new collateral , here 1.25 = (1/ltv) , here if ltv is .8(80%) 

  uint256 helpetC = newLoanAmount*1e18 /ltv;

// this will make sure that newcollateralAmount is approx equal to newLoanAmount*1e18 /ltv
// which will prove that ltv is maintained 

  diff = newcollateralAmount > helpetC ? newcollateralAmount - helpetC : helpetC - newcollateralAmount;


}


  function echidna_test() public returns (bool) {

        
     return diff < 10;

    }
}
