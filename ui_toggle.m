function ui_toggle(hObj,event)
% 该函数由 ui_togglebutton_handler 空间调用
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