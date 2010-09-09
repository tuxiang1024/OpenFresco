function MenuBar(action,varargin)
% MenuBar contains the callbacks for the various menubar options

switch action
    case 'load'
        file = uigetfile('*.mat');
        %Break from function if load file is cancelled
        if file == 0
            return
        %Otherwise...
        else
        load(file);
        handles = guidata(gcf);
        handles.Model = saveData.Model;
        handles.GM = saveData.GM;
        handles.ExpControl = saveData.ExpControl;
        
        %Execute run new test commands to reset test
        handles.Model.StopFlag = 0;
        handles.Model.firstStart = 1;
        %Clear existing figures
        if ~isempty(findobj('Tag','ErrMon'))
            close(findobj('Tag','ErrMon'))
        end
        if ~isempty(findobj('Tag','StructOutDOF1'))
            close(findobj('Tag','StructOutDOF1'))
        end
        if ~isempty(findobj('Tag','StructOutDOF2'))
            close(findobj('Tag','StructOutDOF2'))
        end        
        set(handles.Analysis(6),'SelectedObject',[]);
%         set(handles.Sidebar(3),'SelectedObject',[]);
        
        %Store directory
        handles.Model.DIR = pwd;
        guidata(gcf,handles);
        
        %Adjust display
        active_color = [0 0 0];
        inactive_color = [0.6 0.6 0.6];
        dof1_children = [get(handles.Structure(6),'Children')' get(handles.Structure(8),'Children')'];
        dof2_children = [get(handles.Structure(14),'Children')' get(handles.Structure(16),'Children')'];
        dof3_children = [get(handles.Structure(22),'Children')' get(handles.Structure(24),'Children')'];
        
        set(handles.EC(32),'String',handles.ExpControl.store.CPOptions(2:end));
        set(handles.EC(33),'String',handles.ExpControl.store.CPOptions(2:end));
        
%         %Check ExpControl type
%         if get(handles.EC(3),'Value')
%             handles.ExpControl.Type = 'Simulation';
%         elseif get(handles.EC(4),'Value') || get(handles.EC(2),'Value')
%             handles.ExpControl.Type = 'Real';
%         end
        
        switch handles.Model.Type;
            case '1 DOF'
                %Adjust colors to emphasize active/inactive fields
                set(handles.Structure(7),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(9),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(12),'BackgroundColor',[1 1 1]);
                set(handles.Structure(13),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(15),'BackgroundColor','default','Style','text','String','[m1 0; 0 m2]');
                set(handles.Structure(17),'BackgroundColor','default','Style','text','String','[k11 k12; k21 k22]');
                set(handles.Structure(19),'BackgroundColor','default','Style','text','String','Period');                
                set(handles.Structure(20),'BackgroundColor','default');
                set(handles.Structure(21),'BackgroundColor','default','Style','text','String','zeta');
                set(handles.Structure(23),'BackgroundColor','default','Style','text','String','[m1 0; 0 m2]');
                set(handles.Structure(25),'BackgroundColor','default','Style','text','String','[k11 k12; k21 k22]');
                set(handles.Structure(27),'BackgroundColor','default','Style','text','String','Period');                
                set(handles.Structure(28),'BackgroundColor','default');
                set(handles.Structure(29),'BackgroundColor','default','Style','text','String','zeta');
                set(dof1_children,'ForegroundColor',active_color);
                set(dof2_children,'ForegroundColor',inactive_color);
                set(dof3_children,'ForegroundColor',inactive_color);
                
                %Remove unnecessary plots
                cla(handles.GroundMotions(15));
                cla(handles.GroundMotions(16));
                cla(handles.GroundMotions(17));
                
                %Update Structure strings
                set(handles.Structure(3),'Value',1);
                set(handles.Structure(7),'String',num2str(handles.Model.M));
                set(handles.Structure(9),'String',num2str(handles.Model.K));
                set(handles.Structure(11),'String',sprintf(['Period:    ' num2str(handles.Model.T')]));
                switch handles.Model.DampType
                    case 'Stiffness Proportional'
                        set(handles.Structure(12),'Value',2);
                    case 'Mass Proportional'
                        set(handles.Structure(12),'Value',3);
                end
                set(handles.Structure(13),'String',num2str(handles.Model.Zeta));
                
                %Update Ground Motions
                if length(handles.GM.t{1}) > 1
                    plot(handles.GroundMotions(7), handles.GM.scalet{1}, handles.GM.scaleag{1});
                    set(handles.GroundMotions(3),'String',handles.GM.store.filepath{1},'TooltipString',handles.GM.store.filepath{1});
                    set(handles.GroundMotions(4),'String',num2str(handles.GM.AmpFact(1)));
                    set(handles.GroundMotions(5),'String',num2str(handles.GM.TimeFact(1)));
                    %Store analysis dt
                    handles.GM.dtAnalysis = min(handles.GM.dt);
                    set(handles.Analysis(3),'String',num2str(handles.GM.dtAnalysis));
                end
                
                %Update ExpControl and ExpSetup
                set(handles.EC(6),'String',{'Choose DOF...','DOF 1'},'Value',1);
                set(handles.EC(9),'String','1');
                set(handles.EC(27),'Value',1);
                set(handles.EC(54),'String',{'Existing Control Points...','Control Point 1','Control Point 2'});
                set(handles.EC(57),'Style','edit','String','1');
                set(handles.EC(58),'String','1');
                set(handles.ES(3),'Value',1);
                
                switch handles.ExpControl.Type
                    case 'Simulation'
                        %Select sim tab
                        set(handles.EC(2),'Value',0);
                        set(handles.EC(3),'Value',1);
                        set(handles.EC(4),'Value',0);
                        %Check if DOF(s) have been chosen
                        if isfield(handles.ExpControl,'CtrlDOF')
                            handles.ExpControl.CtrlDOF = 'DOF 1';
                            set(handles.EC(6),'Value',2);
                            set(handles.EC(8),'Value',2);
                            set(handles.EC(12),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(14),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(15),'String',handles.ExpControl.DOF1.epsP);
                            set(handles.EC(17),'String',handles.ExpControl.DOF1.Fy);
                            set(handles.EC(18),'String',handles.ExpControl.DOF1.E0);
                            set(handles.EC(19),'String',handles.ExpControl.DOF1.b);
                            set(handles.EC(21),'String',handles.ExpControl.DOF1.Fy);
                            set(handles.EC(22),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(23),'String',handles.ExpControl.DOF1.b);
                            set(handles.EC(24),'String',handles.ExpControl.DOF1.R0);
                            if ~isempty(handles.ExpControl.DOF1.SimMaterial)
                                index = find(strcmp(handles.ExpControl.store.MatOptions, handles.ExpControl.DOF1.SimMaterial) == 1);
                                set(handles.EC(10),'Value',index);
                                switch index
                                    case 2
                                        %Elastic
                                        handles.ExpControl.store.SimActive = (7:12);
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 3
                                        %EPP
                                        handles.ExpControl.store.SimActive = [7:10 13:15];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 4
                                        %Steel Bilinear
                                        handles.ExpControl.store.SimActive = [7:10 16:19];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 5
                                        %Steel GMP
                                        handles.ExpControl.store.SimActive = [7:10 20:24];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                end
                            end
                        end
                    case 'Real'
                        %Select real tab
                        set(handles.EC(2),'Value',0);
                        set(handles.EC(3),'Value',0);                        
                        set(handles.EC(4),'Value',1);
                        if isfield(handles.ExpControl.RealControl,'Controller');
                            switch handles.ExpControl.RealControl.Controller;
                                case 'LabVIEW'
                                    set(handles.EC(27),'Value',2);
                                    handles.ExpControl.store.RealActive = (25:33);
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                case 'MTSCsi'
                                    set(handles.EC(27),'Value',3);
                                    handles.ExpControl.RealControl.Controller = 'MTSCsi';
                                    handles.ExpControl.store.RealActive = [25:27 34:38];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(35),'String',handles.ExpControl.RealControl.ConfigName);
                                    set(handles.EC(36),'String',handles.ExpControl.RealControl.ConfigPath);
                                    set(handles.EC(38),'String',num2str(handles.ExpControl.RealControl.rampTime));
                                case 'SCRAMNet'
                                    set(handles.EC(27),'Value',4);
                                    handles.ExpControl.RealControl.Controller = 'SCRAMNet';
                                    handles.ExpControl.store.RealActive = [25:27 39:41];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(40),'String',num2str(handles.ExpControl.RealControl.memOffset));
                                    set(handles.EC(41),'String',num2str(handles.ExpControl.RealControl.NumActCh));
                                case 'dSpace'
                                    set(handles.EC(27),'Value',5);
                                    handles.ExpControl.RealControl.Controller = 'dSpace';
                                    handles.ExpControl.store.RealActive = [25:27 42:44];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(43),'Value',handles.ExpControl.RealControl.PCvalue+1);
                                    set(handles.EC(44),'Value',handles.ExpControl.RealControl.boardValue+1);
                                case 'xPCtarget'
                                    set(handles.EC(27),'Value',6);
                                    handles.ExpControl.RealControl.Controller = 'xPCtarget';
                                    handles.ExpControl.store.RealActive = [25:27 45:52];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(46),'Value',handles.ExpControl.RealControl.PCvalue+1);
                                    set(handles.EC(48),'String',handles.ExpControl.RealControl.ipAddr);
                                    set(handles.EC(49),'String',handles.ExpControl.RealControl.ipPort);
                                    set(handles.EC(51),'String',handles.ExpControl.RealControl.appName);
                                    set(handles.EC(52),'String',handles.ExpControl.RealControl.appPath);
                            end
                        end
                end
                
                %Initialize Control Points Page
                set(handles.EC(54),'Value',1);
                set(handles.EC(56),'String','');
                set(handles.EC([60 61 66 67 72 73 78 79]),'Value',1);
                set(handles.EC([62 68 74 80]),'String','1');
                set(handles.EC([63 69 75 81]),'Value',0);
                set(handles.EC([64 65 70 71 76 77 82 83]),'BackgroundColor','default','Style','text','String','');
                
                %Set Structure page on
                h = guihandles(gcf);
                set(h.Struct,'Value',1);
                set(handles.Sidebar(7),'CData',handles.Store.sideButSelect);
                set(handles.Sidebar(8:11),'CData',handles.Store.sideBut);
                set(handles.Structure,'Visible','on');
                set(handles.Structure(handles.Model.StructActive),'Visible','on');
                set(handles.Structure(handles.Model.StructInactive),'Visible','off');
                set(handles.Structure([10 18 26]),'Visible','off');
                set(handles.Structure(30),'Value',0);
                set(handles.GroundMotions,'Visible','off');
                set(get(handles.GroundMotions(7), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(8), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(9), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(15), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(16), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(17), 'Children'), 'Visible', 'off');
                set(handles.ES,'Visible','off');
                set(handles.EC,'Visible','off');
                set(handles.Analysis,'Visible','off');
                
            case '2 DOF A'
                %Adjust colors to emphasize active/inactive fields
                set(handles.Structure(7),'BackgroundColor','default','Style','text','String','Enter mass here');
                set(handles.Structure(9),'BackgroundColor','default','Style','text','String','Enter stiffness here');
                set(handles.Structure(11),'BackgroundColor','default','Style','text','String','Period');
                set(handles.Structure(12),'BackgroundColor','default');
                set(handles.Structure(13),'BackgroundColor','default','Style','text','String','zeta');
                set(handles.Structure(15),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(17),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(20),'BackgroundColor',[1 1 1]);
                set(handles.Structure(21),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(23),'BackgroundColor','default','Style','text','String','[m1 0; 0 m2]');
                set(handles.Structure(25),'BackgroundColor','default','Style','text','String','[k11 k12; k21 k22]');
                set(handles.Structure(27),'BackgroundColor','default','Style','text','String','Period');                
                set(handles.Structure(28),'BackgroundColor','default');
                set(handles.Structure(29),'BackgroundColor','default','Style','text','String','zeta');
                set(dof1_children,'ForegroundColor',inactive_color);
                set(dof2_children,'ForegroundColor',active_color);
                set(dof3_children,'ForegroundColor',inactive_color);
                
                %Remove unnecessary plots
                cla(handles.GroundMotions(15));
                cla(handles.GroundMotions(16));
                cla(handles.GroundMotions(17));
                
                %Update Structure strings
                set(handles.Structure(4),'Value',1);
                m = num2str(handles.Model.M);
                k = num2str(handles.Model.K);
                set(handles.Structure(15),'String',[m(1,:) ';' m(2,:)]);
                set(handles.Structure(17),'String',[k(1,:) ';' k(2,:)])
                set(handles.Structure(19),'String',sprintf(['Period:    ' num2str(handles.Model.T')]));
                switch handles.Model.DampType
                    case 'Stiffness Proportional'
                        set(handles.Structure(20),'Value',2);
                    case 'Mass Proportional'
                        set(handles.Structure(20),'Value',3);
                    case 'Rayleigh'
                        set(handles.Structure(20),'Value',4);
                end
                set(handles.Structure(21),'String',num2str(handles.Model.Zeta));
                
                %Update Ground Motions
                if length(handles.GM.t{1}) > 1
                    plot(handles.GroundMotions(7), handles.GM.scalet{1}, handles.GM.scaleag{1});
                    set(handles.GroundMotions(3),'String',handles.GM.store.filepath{1},'TooltipString',handles.GM.store.filepath{1});
                    set(handles.GroundMotions(4),'String',num2str(handles.GM.AmpFact(1)));
                    set(handles.GroundMotions(5),'String',num2str(handles.GM.TimeFact(1)));
                    %Store analysis dt
                    handles.GM.dtAnalysis = min(handles.GM.dt);
                    set(handles.Analysis(3),'String',num2str(handles.GM.dtAnalysis));
                end
                
                %Update EC and ES strings
                set(handles.EC(6),'String',{'Choose Story...','Story 1','Story 2'},'Value',1);
                set(handles.EC(7:10),'Visible','off');
                set(handles.EC(9),'String','2');
                set(handles.EC(27),'Value',1);
                set(handles.EC(54),'String',{'Existing Control Points...','Control Point 1','Control Point 2','Control Point 3','Control Point 4'});
                set(handles.EC(57),'Style','popupmenu','String',{'Choose Node...','Node 1','Node 2'});
                set(handles.EC(58),'String','1');
                set(handles.ES(4),'Value',1);
                
                switch handles.ExpControl.Type
                    case 'Simulation'
                        %Select sim tab
                        set(handles.EC(2),'Value',0);
                        set(handles.EC(3),'Value',1);
                        set(handles.EC(4),'Value',0);
                        %Check if DOF(s) have been chosen
                        if isfield(handles.ExpControl,'CtrlDOF')
                            handles.ExpControl.CtrlDOF = 'DOF 1';
                            set(handles.EC(6),'Value',2);
                            set(handles.EC(8),'Value',2);
                            set(handles.EC(12),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(14),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(15),'String',handles.ExpControl.DOF1.epsP);
                            set(handles.EC(17),'String',handles.ExpControl.DOF1.Fy);
                            set(handles.EC(18),'String',handles.ExpControl.DOF1.E0);
                            set(handles.EC(19),'String',handles.ExpControl.DOF1.b);
                            set(handles.EC(21),'String',handles.ExpControl.DOF1.Fy);
                            set(handles.EC(22),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(23),'String',handles.ExpControl.DOF1.b);
                            set(handles.EC(24),'String',handles.ExpControl.DOF1.R0);
                            if ~isempty(handles.ExpControl.DOF1.SimMaterial)
                                index = find(strcmp(handles.ExpControl.store.MatOptions, handles.ExpControl.DOF1.SimMaterial) == 1);
                                set(handles.EC(10),'Value',index);
                                switch index
                                    case 2
                                        %Elastic
                                        handles.ExpControl.store.SimActive = (7:12);
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 3
                                        %EPP
                                        handles.ExpControl.store.SimActive = [7:10 13:15];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 4
                                        %Steel Bilinear
                                        handles.ExpControl.store.SimActive = [7:10 16:19];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 5
                                        %Steel GMP
                                        handles.ExpControl.store.SimActive = [7:10 20:24];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                end
                            end
                        end
                    case 'Real'
                        %Select real tab
                        set(handles.EC(2),'Value',0);
                        set(handles.EC(3),'Value',0);                        
                        set(handles.EC(4),'Value',1);
                        if isfield(handles.ExpControl.RealControl,'Controller');
                            switch handles.ExpControl.RealControl.Controller;
                                case 'LabVIEW'
                                    set(handles.EC(27),'Value',2);
                                    handles.ExpControl.store.RealActive = (25:33);
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                case 'MTSCsi'
                                    set(handles.EC(27),'Value',3);
                                    handles.ExpControl.RealControl.Controller = 'MTSCsi';
                                    handles.ExpControl.store.RealActive = [25:27 34:38];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(35),'String',handles.ExpControl.RealControl.ConfigName);
                                    set(handles.EC(36),'String',handles.ExpControl.RealControl.ConfigPath);
                                    set(handles.EC(38),'String',num2str(handles.ExpControl.RealControl.rampTime));
                                case 'SCRAMNet'
                                    set(handles.EC(27),'Value',4);
                                    handles.ExpControl.RealControl.Controller = 'SCRAMNet';
                                    handles.ExpControl.store.RealActive = [25:27 39:41];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(40),'String',num2str(handles.ExpControl.RealControl.memOffset));
                                    set(handles.EC(41),'String',num2str(handles.ExpControl.RealControl.NumActCh));
                                case 'dSpace'
                                    set(handles.EC(27),'Value',5);
                                    handles.ExpControl.RealControl.Controller = 'dSpace';
                                    handles.ExpControl.store.RealActive = [25:27 42:44];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(43),'Value',handles.ExpControl.RealControl.PCvalue+1);
                                    set(handles.EC(44),'Value',handles.ExpControl.RealControl.boardValue+1);
                                case 'xPCtarget'
                                    set(handles.EC(27),'Value',6);
                                    handles.ExpControl.RealControl.Controller = 'xPCtarget';
                                    handles.ExpControl.store.RealActive = [25:27 45:52];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(46),'Value',handles.ExpControl.RealControl.PCvalue+1);
                                    set(handles.EC(48),'String',handles.ExpControl.RealControl.ipAddr);
                                    set(handles.EC(49),'String',handles.ExpControl.RealControl.ipPort);
                                    set(handles.EC(51),'String',handles.ExpControl.RealControl.appName);
                                    set(handles.EC(52),'String',handles.ExpControl.RealControl.appPath);
                            end
                        end
                end
                
                %Initialize Control Points Page
                set(handles.EC(54),'Value',1);
                set(handles.EC(56),'String','');
                set(handles.EC([60 61 66 67 72 73 78 79]),'Value',1);
                set(handles.EC([62 68 74 80]),'String','1');
                set(handles.EC([63 69 75 81]),'Value',0);
                set(handles.EC([64 65 70 71 76 77 82 83]),'BackgroundColor','default','Style','text','String','');                
                
                %Set Structure page on
                h = guihandles(gcf);
                set(h.Struct,'Value',1);
                set(handles.Sidebar(7),'CData',handles.Store.sideButSelect);
                set(handles.Sidebar(8:11),'CData',handles.Store.sideBut);
                set(handles.Structure,'Visible','on');
                set(handles.Structure(handles.Model.StructActive),'Visible','on');
                set(handles.Structure(handles.Model.StructInactive),'Visible','off');
                set(handles.Structure([10 18 26]),'Visible','off');
                set(handles.Structure(30),'Value',0.5);
                set(handles.GroundMotions,'Visible','off');
                set(get(handles.GroundMotions(7), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(8), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(9), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(15), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(16), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(17), 'Children'), 'Visible', 'off');
                set(handles.ES,'Visible','off');
                set(handles.EC,'Visible','off');
                set(handles.Analysis,'Visible','off');
                
            case '2 DOF B'
                %Adjust colors to emphasize active/inactive fields
                set(handles.Structure(7),'BackgroundColor','default','Style','text','String','Enter mass here');
                set(handles.Structure(9),'BackgroundColor','default','Style','text','String','Enter stiffness here');
                set(handles.Structure(11),'BackgroundColor','default','Style','text','String','Period');                
                set(handles.Structure(12),'BackgroundColor','default');
                set(handles.Structure(13),'BackgroundColor','default','Style','text','String','zeta');
                set(handles.Structure(15),'BackgroundColor','default','Style','text','String','[m1 0; 0 m2]');
                set(handles.Structure(17),'BackgroundColor','default','Style','text','String','[k11 k12; k21 k22]');
                set(handles.Structure(19),'BackgroundColor','default','Style','text','String','Period');                
                set(handles.Structure(20),'BackgroundColor','default');
                set(handles.Structure(21),'BackgroundColor','default','Style','text','String','zeta');
                set(handles.Structure(23),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(25),'BackgroundColor',[1 1 1],'Style','edit');
                set(handles.Structure(28),'BackgroundColor',[1 1 1]);
                set(handles.Structure(29),'BackgroundColor',[1 1 1],'Style','edit');
                set(dof1_children,'ForegroundColor',inactive_color);
                set(dof2_children,'ForegroundColor',inactive_color);
                set(dof3_children,'ForegroundColor',active_color);
                
                %Update Structure strings
                set(handles.Structure(5),'Value',1);
                m = num2str(handles.Model.M);
                k = num2str(handles.Model.K);
                set(handles.Structure(23),'String',[m(1,:) ';' m(2,:)]);
                set(handles.Structure(25),'String',[k(1,:) ';' k(2,:)])
                set(handles.Structure(27),'String',sprintf(['Period:    ' num2str(handles.Model.T')]));
                switch handles.Model.DampType
                    case 'Stiffness Proportional'
                        set(handles.Structure(28),'Value',2);
                    case 'Mass Proportional'
                        set(handles.Structure(28),'Value',3);
                    case 'Rayleigh'
                        set(handles.Structure(28),'Value',4);
                end
                set(handles.Structure(29),'String',num2str(handles.Model.Zeta));
                
                %Update Ground Motions
                if length(handles.GM.t{1}) > 1
                    plot(handles.GroundMotions(7), handles.GM.scalet{1}, handles.GM.scaleag{1});
                    plot(handles.GroundMotions(8), handles.GM.Spectra{1}.T, handles.GM.Spectra{1}.psdAcc);
                    plot(handles.GroundMotions(9), handles.GM.Spectra{1}.T, handles.GM.Spectra{1}.dsp);
                    set(handles.GroundMotions(3),'String',handles.GM.store.filepath{1},'TooltipString',handles.GM.store.filepath{1});
                    set(handles.GroundMotions(4),'String',num2str(handles.GM.AmpFact(1)));
                    set(handles.GroundMotions(5),'String',num2str(handles.GM.TimeFact(1)));
                    %Store analysis dt
                    handles.GM.dtAnalysis = min(handles.GM.dt);
                    set(handles.Analysis(3),'String',num2str(handles.GM.dtAnalysis));
                end
                if length(handles.GM.t{2}) > 1
                    plot(handles.GroundMotions(15), handles.GM.scalet{2}, handles.GM.scaleag{2});
                    plot(handles.GroundMotions(16), handles.GM.Spectra{2}.T, handles.GM.Spectra{2}.psdAcc);
                    plot(handles.GroundMotions(17), handles.GM.Spectra{2}.T, handles.GM.Spectra{2}.dsp);
                    set(handles.GroundMotions(11),'String',handles.GM.store.filepath{2},'TooltipString',handles.GM.store.filepath{2});
                    set(handles.GroundMotions(12),'String',num2str(handles.GM.AmpFact(1)));
                    set(handles.GroundMotions(13),'String',num2str(handles.GM.TimeFact(1)));
                end
                
                %Update EC and ES strings
                set(handles.EC(6),'String',{'Choose DOF...','DOF 1','DOF 2'},'Value',1);
                set(handles.EC(7:10),'Visible','off');
                set(handles.EC(9),'String','2');
                set(handles.EC(27),'Value',1);
                set(handles.EC(54),'String',{'Existing Control Points...','Control Point 1','Control Point 2'});
                set(handles.EC(57),'Style','edit','String','1');
                set(handles.EC(58),'String','2');
                set(handles.ES(5),'Value',1);
                
                switch handles.ExpControl.Type
                    case 'Simulation'
                        %Select sim tab
                        set(handles.EC(2),'Value',0);
                        set(handles.EC(3),'Value',1);
                        set(handles.EC(4),'Value',0);
                        %Check if DOF(s) have been chosen
                        if isfield(handles.ExpControl,'CtrlDOF')
                            handles.ExpControl.CtrlDOF = 'DOF 1';
                            set(handles.EC(6),'Value',2);
                            set(handles.EC(8),'Value',2);
                            set(handles.EC(12),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(14),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(15),'String',handles.ExpControl.DOF1.epsP);
                            set(handles.EC(17),'String',handles.ExpControl.DOF1.Fy);
                            set(handles.EC(18),'String',handles.ExpControl.DOF1.E0);
                            set(handles.EC(19),'String',handles.ExpControl.DOF1.b);
                            set(handles.EC(21),'String',handles.ExpControl.DOF1.Fy);
                            set(handles.EC(22),'String',handles.ExpControl.DOF1.E);
                            set(handles.EC(23),'String',handles.ExpControl.DOF1.b);
                            set(handles.EC(24),'String',handles.ExpControl.DOF1.R0);
                            if ~isempty(handles.ExpControl.DOF1.SimMaterial)
                                index = find(strcmp(handles.ExpControl.store.MatOptions, handles.ExpControl.DOF1.SimMaterial) == 1);
                                set(handles.EC(10),'Value',index);
                                switch index
                                    case 2
                                        %Elastic
                                        handles.ExpControl.store.SimActive = (7:12);
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 3
                                        %EPP
                                        handles.ExpControl.store.SimActive = [7:10 13:15];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 4
                                        %Steel Bilinear
                                        handles.ExpControl.store.SimActive = [7:10 16:19];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                    case 5
                                        %Steel GMP
                                        handles.ExpControl.store.SimActive = [7:10 20:24];
                                        set(handles.EC(11:24),'Visible','off');
                                        set(handles.EC(handles.ExpControl.store.SimActive),'Visible','on');
                                end
                            end
                        end
                    case 'Real'
                        %Select real tab
                        set(handles.EC(2),'Value',0);
                        set(handles.EC(3),'Value',0);                        
                        set(handles.EC(4),'Value',1);
                        if isfield(handles.ExpControl.RealControl,'Controller');
                            switch handles.ExpControl.RealControl.Controller;
                                case 'LabVIEW'
                                    set(handles.EC(27),'Value',2);
                                    handles.ExpControl.store.RealActive = (25:33);
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                case 'MTSCsi'
                                    set(handles.EC(27),'Value',3);
                                    handles.ExpControl.RealControl.Controller = 'MTSCsi';
                                    handles.ExpControl.store.RealActive = [25:27 34:38];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(35),'String',handles.ExpControl.RealControl.ConfigName);
                                    set(handles.EC(36),'String',handles.ExpControl.RealControl.ConfigPath);
                                    set(handles.EC(38),'String',num2str(handles.ExpControl.RealControl.rampTime));
                                case 'SCRAMNet'
                                    set(handles.EC(27),'Value',4);
                                    handles.ExpControl.RealControl.Controller = 'SCRAMNet';
                                    handles.ExpControl.store.RealActive = [25:27 39:41];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(40),'String',num2str(handles.ExpControl.RealControl.memOffset));
                                    set(handles.EC(41),'String',num2str(handles.ExpControl.RealControl.NumActCh));
                                case 'dSpace'
                                    set(handles.EC(27),'Value',5);
                                    handles.ExpControl.RealControl.Controller = 'dSpace';
                                    handles.ExpControl.store.RealActive = [25:27 42:44];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(43),'Value',handles.ExpControl.RealControl.PCvalue+1);
                                    set(handles.EC(44),'Value',handles.ExpControl.RealControl.boardValue+1);
                                case 'xPCtarget'
                                    set(handles.EC(27),'Value',6);
                                    handles.ExpControl.RealControl.Controller = 'xPCtarget';
                                    handles.ExpControl.store.RealActive = [25:27 45:52];
                                    set(handles.EC(25:52),'Visible','off');
                                    set(handles.EC(handles.ExpControl.store.RealActive),'Visible','on');
                                    set(handles.EC(46),'Value',handles.ExpControl.RealControl.PCvalue+1);
                                    set(handles.EC(48),'String',handles.ExpControl.RealControl.ipAddr);
                                    set(handles.EC(49),'String',handles.ExpControl.RealControl.ipPort);
                                    set(handles.EC(51),'String',handles.ExpControl.RealControl.appName);
                                    set(handles.EC(52),'String',handles.ExpControl.RealControl.appPath);
                            end
                        end
                end

                %Initialize Control Points Page
                set(handles.EC(54),'Value',1);
                set(handles.EC(56),'String','');
                set(handles.EC([60 61 66 67 72 73 78 79]),'Value',1);
                set(handles.EC([62 68 74 80]),'String','1');
                set(handles.EC([63 69 75 81]),'Value',0);
                set(handles.EC([64 65 70 71 76 77 82 83]),'BackgroundColor','default','Style','text','String','');
                
                %Set Structure page on
                h = guihandles(gcf);
                set(h.Struct,'Value',1);
                set(handles.Sidebar(7),'CData',handles.Store.sideButSelect);
                set(handles.Sidebar(8:11),'CData',handles.Store.sideBut);
                set(handles.Structure,'Visible','on');
                set(handles.Structure(handles.Model.StructActive),'Visible','on');
                set(handles.Structure(handles.Model.StructInactive),'Visible','off');
                set(handles.Structure([10 18 26]),'Visible','off');
                set(handles.Structure(30),'Value',1);
                set(handles.GroundMotions,'Visible','off');
                set(get(handles.GroundMotions(7), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(8), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(9), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(15), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(16), 'Children'), 'Visible', 'off');
                set(get(handles.GroundMotions(17), 'Children'), 'Visible', 'off');
                set(handles.ES,'Visible','off');
                set(handles.EC,'Visible','off');
                set(handles.Analysis,'Visible','off');
        end
        guidata(gcbf, handles);
        end

        
    case 'save'
        saveData = guidata(gcf);
        uisave('saveData');
end