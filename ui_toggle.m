function ui_toggle(hObj,event)
% �ú����� ui_togglebutton_handler �ռ����
Value = get(hObj,'Value');
if Value == 1
    set(hObj,'String','Continue');
    set(hObj,'BackgroundColor',[0.5,0.0,0.0]);
    uiwait(gcf); 
else
    set(hObj,'String','Pause');
    set(hObj,'BackgroundColor',[0,0.5,0.5]);
    uiresume(gcbf);
end