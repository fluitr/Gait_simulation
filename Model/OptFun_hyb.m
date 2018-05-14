function val = OptFun_hyb(x)
%% This function runs the simulation for optimalisation
%% param
assignin('base','param',x);

val_inv = OptFun_invCPG(evalin('base','param'));
if isnan(val_inv)
    val = nan;
elseif val_inv > 2.75
   val = 1E4 + val_inv; 
else
    val_for = OptFun_forCPG(evalin('base','param'));
    if isnan(val_for)
        val = nan;
    else
        val = val_for;
    end
end