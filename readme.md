# here is how liquidation formula works where liquidators get's 104 % or 105% or 100+n percent of what they provide to liquidate user's.

example --> let say a protocol has a ltv set as 80% which means loan amount price is 100 and collateral amount price is 125 and liquidator earning is fixed 4 percent , but due to some price change now , user loan amount 
            price reaches to 110 , when liquidator comes to liquidate this position because now it has a ltv of 0.88 %  , instead of liquidating borrower's entire position , the protocol will make sure that
            borrower's position to only get enough liquidated to restore their TVL back to  0.8 (80%) from 0.88(88%) and make sure that liquidator also get's 4 percent extra of what they provide (104% of what they provide).


# we will also derive this formula as well below :-->

`liquidatorWillPay = currentLoan - (ltv * collateral) /   1 - (earnPercent * ltv);`   


1) ltv --> 0.8 , 0.7 ,0.5 ( which represents 80%,70%,50%)
  
3) earnPercent --> 1.04,1.05,1.06 ( which means 104 % , 105% , 106%) beacuse when liquidator provides 100 dollar , he will get 104 dollar in return
  
5) collateral --> current colleteral price he holds for this currentLoan price.

Above formula will give a value which liquidator will provide based on user's collateral price and loan amount price, ok but what will we do with the value we received from above formula

1) newLoan = currentLoan  - liquidatorWillPay;  --> so now this is his new loan amount price.
2) newCollateral =  currentCollateral - (liquidatorWillPay * earnPercent ( 104% or 105%) )  // so this is his new colleteral price.

`based on the above prices you can get the quantity of new loan amount and new collateral amount.`

# How above formual changes the user's position.

 1)  newLoan = `newCollateral * ltv ` --> now check aganist above value of `newLoan`, this proves that new position is back to their ltv
 2)  newCollateral  = `(currentLoan - newLoan) * earnPercent ` (1.04)  --> check aganist above value `newCollateral `, this proves that liquidator get's `liquidatorWillPay * earnPercent`
                   
Ok but how do we make sure that this new loanAmountPrice and new collateralAmountPrice is back to their ltv and liquidator get's 104 percent of what they provided.

# Example 

ltv = 0.8(80%)

earnPercent = 1.04 (liquidator earns 4%)

currentLoan = 110

currentCollateral = 125


1) liquidatorWillPay = `110 - ( 0.8 * 125) /  1-( 1.04 * 0.8)`

   liquidatorWillPay = 59.523

3) newLoan = `currentLoan  - liquidatorWillPay`;

   newLoan = 110 - 59.523
   newLoan = 50.477


5) newCollateral =  `currentCollateral - liquidatorWillPay * earnPercent`

   newCollateral =  125 - (59.523 * 1.04)
   newCollateral = 63.09608


check if `newcollateral * ltv` is 0.8  again.  


newLoan ==  `newCollateral * ltv`  

50.477  ==  50.477 (approx)

which proves our formula works


# Prove of above formula `liquidatorWillPay`  

`currentColleteral - ( liquidatorWillPay * earnPercent ) =  (currentLoan - liquidatorWillPay) / ltv`  

ok what this formula says,  that `newCollateral` = (currentColleteral  - what liquidator pays * earn percent)  

and (currentLoan - liquidatorWillPay) = `newLoan` when multiplied by 1.25 (ltv of 80 which means collateral should be 1.25 times of loan amount , ie. 1 /.8 = 1.25)  

so this equation means is that `new collateral position` should be equal to 1.25 times of `newLoanAmount`  or `1 /ltv` times of  `newLoanAmount`

 
 
 let's proof it :-->  
 

`currentColleteral - ( liquidatorWillPay * earnPercent ) =  (currentLoan - liquidatorWillPay) / ltv`  


 `ltv (currentColleteral -  liquidatorWillPay * earnPercent)  = currentLoan - liquidatorWillPay`  
 
                                 
 `currentColleteral*ltv - liquidatorWillPay * earnPercent * ltv = currentLoan - liquidatorWillPay`  
 

 `- liquidatorWillPay * earnPercent * ltv + liquidatorWillPay  =   currentLoan  - currentColleteral*ltv`
   

   `liquidatorWillPay( - earnPercent * ltv + 1 ) = currentLoan  - currentColleteral*ltv`
   
   
  `liquidatorWillPay =  currentLoan  - (currentColleteral*ltv) /  1 - (earnPercent * ltv)`  
   

# Correct use of this formula 

Make sure that current loan price / collateral price  is above ltv  or else it will wrong data.  

Make sure that what `liquidatorWillPay` return multiply it with `earnPercent` and make sure it is less than `currentCollateralPrice`  --> or else liquidator will get more than user has collateral.  


why the second statement let see with an example :-->

current collateral is  125 and earnPercent is 1.04 (104%)  so 125 / 1.04 = 120.192307  ,if liquidator provides more than 120.192307 then 121 * 1.04 = 125 .84 which exceds the user collateral.  

so `liquidatorWillPay * earnPercent <= currentCollateral`


