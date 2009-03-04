function [Obj,Obs] = measureObj(Rob,Cam,Obj,ns,reproject,Obs)

% MEASUREOBJ Measure object via active search
%   OBJ = MEASUREOBJ(ROB,CAM,OBJ,NS) searches the object OBJ
%   inside the NS-sigma projected ellipses that are previously
%   computed for camera CAM. It updates the whole OBJ structure.
%
%   OBJ = MEASUREOBJ(...,REPROJ,OBS) with REPROJ = true
%   additionally reprojects the object onto the image plane with
%   observation OBS

cam = Cam.id;

% re-project object to get actual linearizations
if (nargin >= 4) & reproject
   Obj = projectObject(...
      Cam,...
      Obj,...
      Obs.R);
end

% i. Search patch
patchSize = size(Obj.sig.I,1);
Obj.Prj(cam).region = pnt2par(...
   Obj,...
   ns,...
   cam,...
   patchSize); %  region to scan

% Obj.wPatch = patchResize(...
%    Obj.sig,...
%    Obj.Prj(cam).sr^-1); % warp patch

[ Obj.Prj(cam).y,...
   Obj.Prj(cam).sc,...
   Obj.Prj(cam).cPatch] ...
   ...
   = patchScan(...
   ...
   cam,...
   Obj.wPatch,...
   Obj.Prj(cam).region,...
   Obj.Prj(cam).region.x0,...
   .98,...
   .89);

Obs.y = Obj.Prj(cam).y;