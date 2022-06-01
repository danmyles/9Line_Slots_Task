function [] = print_payments(sessionInfo)
% ----------------------------------------------------------------------
% [] = printPayments(sessionInfo)
% ----------------------------------------------------------------------
% Goal of the function :
% To print final payment to command window
% ----------------------------------------------------------------------
% Input(s) :
% sessionInfo
% Contains final payment info
% ----------------------------------------------------------------------
% Function created by Dan Myles (dan.myles@monash.edu)
% Last update : June 2022
% Project : 9_Line_Slots_Task
% Version : 2021a
% ----------------------------------------------------------------------

    fprintf(2, ...
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"+ ...
    "----------------------------\n" + ...
    "  Final Credits:  " + sessionInfo.finalCredits + "\n" + ... 
    "  Bonus Payment: $" + sessionInfo.bonusPayment + "\n" + ... 
    "  Travel Costs : $" + sessionInfo.travelCosts + "\n" + ... 
    "----------------------------\n" + ...
    "  <strong>Total Payment: $" + sessionInfo.totalPayment + "</strong>\n" +... 
    "----------------------------\n\n")
end

