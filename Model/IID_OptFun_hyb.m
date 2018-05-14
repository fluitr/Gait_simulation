function val = IID_OptFun_hyb(x)
%% This function runs the simulation for optimalisation
%% param
assignin('base','param',x);

val_inv = IID_OptFun_inv(evalin('base','param'));
if isnan(val_inv)
    val = nan;
elseif val_inv > 2.5
   val = 1E4 + val_inv; 
else
    val_for = IID_OptFun_for(evalin('base','param'));
    if isnan(val_for)
        val = nan;
    else
        val = val_for;
    end
end