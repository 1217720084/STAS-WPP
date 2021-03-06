function [C,K] = dampingCLin (ces,dqdt,dmu,d2mu)
%
% Build the damping matrix if the damping is to be accounted for in
% the full model, as opposed to specifying an effective modal damping
% ratio on the mode-reduced model.  Linearized with respect to q's.
%
% Version:        Changes:
% --------        -------------
% 06.03.2018      Original code.
%
% Version:        Verification:
% --------        -------------
% 06.03.2018      Rotating cantilever, wind turbine modal analysis
%                 give the expected results.  Linearization verified
%                 by complex step.
%
% Inputs:
% -------
% ces             : Element damping matrix.
% dmu             : dmu/dq.
%
% Outputs:
% --------
% C               : 18-by-18 damping matrix.
% dC              : dC/dq for the relevant [qB;qn1;qn2].

C = zeros(18,18);
K = zeros(18,18);

% Say that no damping is associated with the body reference DOFs.
% Let it all be elastic.
C(7:18,7:18) = (dmu.')*ces*dmu;

for iq = 1:12

   ic12 = 12*(iq-1);

   K(7:18,iq+6) = ((d2mu(:,ic12+[1:12]).')*ces*dmu ...
                +  (dmu.')*ces*d2mu(:,ic12+[1:12]))*dqdt(7:18);

end
