function rect = GINPUTRECT(arg1)

   fig=gcf;
   figure(fig);

   char = 0;
   drawnow();
   bounds=[xlim();ylim()];
   roi =images.roi.Rectangle(gca,'Position',[mean(bounds(1,:))/2,mean(bounds(2,:))/2,diff(bounds(1,:))/2,diff(bounds(2,:))/2],'Color','y');
   while true
      % Use no-side effect WAITFORBUTTONPRESS
      waserr = 0;
      try
	keydown = wfbp;
      catch
	waserr = 1;
      end
      if(waserr == 1)
         if(ishandle(fig))
            set(fig,'units',fig_units);
	    uirestore(state);
            error('Interrupted');
         else
            error('Interrupted by figure deletion');
         end
      end
      
      ptr_fig = get(0,'CurrentFigure');
      if(ptr_fig == fig)
         if keydown
            char = get(fig, 'CurrentCharacter');
%            
         end        
         if(char == 13) % & how_many ~= 0)

            rect=get(roi,'Position');
            delete(roi)

            break;
         end
         
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = [];

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
  h=findall(fig,'type','uimenu','accel','C');   % Disabling ^C for edit menu so the only ^C is for
  set(h,'accel','');                            % interrupting the function.
  keydown = waitforbuttonpress;
  current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
  if~isempty(current_char) & (keydown == 1)           % If the character was generated by the 
	  if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
		  waserr = 1;                             % so that it errors out. 
	  end
  end
  
  set(h,'accel','C');                                 % Set back the accelerator for edit menu.
catch
  waserr = 1;
end
drawnow;
if(waserr == 1)
   set(h,'accel','C');                                % Set back the accelerator if it errored out.
   error('Interrupted');
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%