function [y,dy] = gains1 (x,tab);

% Utilize Matlab/Octave spline interpolation capability.  "tab" is then
% a polynomial structure generated by mkpp (or as a part of interp1).
%
% NOTE: Can't use ppval() with complex step, so this routine is a work-around.

% Here's the efficient way that doesn't work with complex step.
%y = ppval(tab,x);
%[breaks,coefs,l,k,d] = unmkpp(tab);
%dtab = mkpp(breaks,repmat(k-1:-1:1,d*l,1).*coefs(:,1:k-1),d);
%dy = ppval(dtab,x);

% And a way that works with complex step on x.  CAUTION, 'pchip' polynomials
% as would often be used with a lookup table don't give accurate second
% derivatives, for this the table should be generated with 'spline' -- but
% this risks unwanted waviness in the interpolation.
[breaks,coefs,L,k,d] = unmkpp(tab);
xbrk = max(min(real(x),real(breaks(L+1))),real(breaks(1)));
iseg = (xbrk >= real(breaks(1:L))) & (xbrk < real(breaks(2:L+1)));
if (xbrk >= real(breaks(L+1)))
   iseg(L) = 1;
end
b = breaks(iseg);
c = coefs(iseg,:);
s = x - b;
y = c(4) + s*(c(3) + s*(c(2) + s*c(1)));
dy = c(3) + s*(2*c(2) + 3*s*c(1));