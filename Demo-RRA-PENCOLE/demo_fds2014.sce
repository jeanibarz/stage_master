tank_fig_id = 1;
sim_fig_id = 2;
control_fig_id = 3;


// Tank 1 meter diameter
diameter = 1;

// Tank is a cylinder 1 meter high
height = 1;

// Some dimensions of the tank
A_r = %pi * (diameter/2)^2;
MaxVolume = A_r * height;


// We do the hypothesis that it takes one 
// minute to fill the tank if output flow with
// a maximal input flow

max_input_flow = MaxVolume/60;

// ? c ? no output flow
c=0.01;



// a leak is an output flow (m^3.s^{-1})
global LEAK;
LEAK = -0.005;

// injection time
global TINJECT;
TINJECT= 180;

// let us simulate the system
h0=0.3;
t0=0;
t=0:0.1:360;

global input_scenario;
input_scenario = 1;


function hdot=tank(t,h)
  hdot = input_flow(t)/A_r - c/A_r * h
endfunction


function de=input_flow(t)
    if input_scenario==1 then
      if t < 50 then
        de = max_input_flow
      elseif t < 60 then
        de = 0
      elseif t < 110 then
        de = max_input_flow
      elseif t < 180 then
        de = 0
      elseif t < 210 then
         de = max_input_flow
      elseif t < 240 then
         de = 0
      elseif  t < 320 then
         de = max_input_flow
      else
         de = 0 
      end
    elseif input_scenario==2  then
        de = max_input_flow / 4;
    end
endfunction



function l=leak(t)
  if t < TINJECT then 
    l = 0
  else
    l = LEAK;
  end
endfunction

function hdot=leak_tank(t,h)
  hdot = input_flow(t)/A_r - c/A_r * h + leak(t)/A_r
endfunction    




function hok=simulate_system_ok()
    hok = ode(h0,t0,t,tank);
endfunction


function hleak=simulate_system_leak()
    hleak = ode(h0,t0,t,leak_tank);
endfunction 


//  the simulated output
function f=output_flow(i,h)
  f = c * h(i)
endfunction



function create_control_panel()
    control_fig = figure(control_fig_id,"Figure_name","Contrôle","infobar_visible", "off",...
                        "toolbar_visible", "off",...
                        "dockable", "off",...
                        "menubar", "none",...
                        "default_axes", "off", ...
                        "Position",[150 150 300 800],...
                        "resize", "off",...
                        "BackgroundColor", [0.9 0.9 0.9],...
                        "Tag", "control_fig_tag")
  
  
    // A popup menu
    scenario_menu = uicontrol(control_fig, "Position", [15 735 240 20],...
    "Style", "popupmenu",...
    "String", gettext("ouverture/fermeture | constant"),...
    "Callback", "scenario_menu_callback();",...
    "Tag", "scenario_menu_tag");
    scenario_menu_title = uicontrol(control_fig, "Position", [16 755 80 15],...
                                 "Style", "text",...
                                 "FontSize", 11,...
                                 "String", gettext("Scénario"),...
                                 "BackgroundColor", [0.9 0.9 0.9]);
                                 
     
        leak_slider_frame = uicontrol(control_fig, "Position", [15 600 240 105], ...
        "Style", "frame", ...
        "Relief", "groove",...
        "BackgroundColor", [0.8 0.8 0.8]);
        leak_slider_frame_title = uicontrol(control_fig, "Position", [16 710 200 15],...
        "Style", "text",...
        "FontSize", 11,...
        "String", gettext("Taille de la fuite"),...
        "BackgroundColor", [0.9 0.9 0.9]);
        
        leak_slider_text = uicontrol(control_fig, "Position", [20 611 230 20],...
        "Style", "text",...
        "FontSize", 11,...
        "FontWeight", "bold",...
        "BackgroundColor",[1 1 1],...
        "HorizontalAlignment", "center",...
        "Tag", "leak_slider_text_tag");
        
        leak_slider = uicontrol(control_fig, "Position", [20 630 230 55],...
        "Style", "slider",...
        "Min", 0,...
        "Max", 0.01,...
        "Value", 0.005,...
        "SliderStep", [2 10],...
        "Tag", "leak_slider_tag",...
        "Callback", "leak_slider_update();");
        // Update the text displayed
        leak_slider_update();                            
        
        time_slider_frame = uicontrol(control_fig, "Position", [15 470 240 105], ...
        "Style", "frame", ...
        "Relief", "groove",...
        "BackgroundColor", [0.8 0.8 0.8]);
        time_slider_frame_title = uicontrol(control_fig, "Position", [16 580 200 15],...
        "Style", "text",...
        "FontSize", 11,...
        "String", gettext("Date d''injection de la fuite"),...
        "BackgroundColor", [0.9 0.9 0.9]);
        
        time_slider_text = uicontrol(control_fig, "Position", [20 481 230 20],...
        "Style", "text",...
        "FontSize", 11,...
        "FontWeight", "bold",...
        "BackgroundColor",[1 1 1],...
        "HorizontalAlignment", "center",...
        "Tag", "time_slider_text_tag");
        
        time_slider = uicontrol(control_fig, "Position", [20 500 230 55],...
        "Style", "slider",...
        "Min", 0,...
        "Max", 360,...
        "Value", 180,...
        "SliderStep", [2 10],...
        "Tag", "time_slider_tag",...
        "Callback", "time_slider_update();");
        // Update the text displayed
        time_slider_update();   
        
        run_button = uicontrol(control_fig, "Position", [14 15 165 25],...
        "Style", "pushbutton",...
        "String", gettext("Lancer la simulation"),...
        "FontSize", 11,...
        "Callback", "runSimulation();");
                         

endfunction

function time_slider_update()
    sl = get("time_slider_tag");
    txt = get("time_slider_text_tag");
    global TINJECT;
    TINJECT = get(sl, "Value");
    set(txt, "String", string(TINJECT) + gettext(" secondes") );
endfunction

function leak_slider_update()
    sl = get("leak_slider_tag");
    txt = get("leak_slider_text_tag");
    global LEAK;
    LEAK = -get(sl, "Value");
    set(txt, "String", string(-LEAK) + gettext("m^3.s^{-1}") );
endfunction


function scenario_menu_callback()
    pop = get("scenario_menu_tag");
    items = get(pop, "String");
    global input_scenario;
    input_scenario = get(pop, "Value");
endfunction


function demo_fds2014()
    
    //tank_fig = figure(tank_fig_id,"Figure_name","Récipient","BackgroundColor",[1,1,1],"layout", "border");
    //sim_fig = figure(sim_fig_id,"Figure_name","Simulation","BackgroundColor",[1,1,1],"layout", "border");
    create_control_panel();
endfunction


function create_simulation_plots()
    scf(sim_fig_id);
    subplot(3,1,1);
    set(gca(),"data_bounds",[0,360,0,1]);
    xtitle("Hauteur réelle de liquide dans le récipient (non observable)","", "hauteur (m)");
    a=get("current_axes");
    title= a.title;
    title.font_size=4;
    title.font_style=5;
    x_label=a.x_label;
    x_label.font_size= 3;
    y_label=a.y_label;
    y_label.font_size= 3;
    
    
    
    subplot(3,1,2);
    set(gca(),"data_bounds",[0,360,-0.002,0.007]);
    xtitle("Valeur du résidu observée","","débit (m^3.s-1))");
    a=get("current_axes");
    title= a.title;
    title.font_size=4;
    title.font_style=5;
    x_label=a.x_label;
    x_label.font_size= 3;
    y_label=a.y_label;
    y_label.font_size= 3;
    alarm = [0.002,0.002];
    plot([0,360],alarm,'g');
    
    
    subplot(3,1,3);
    set(gca(),"data_bounds",[0,360,-0.1,1.1]);
    xtitle("Signal alarme (détection de fuite)","temps (s)","oui/non");
    a=get("current_axes");
    title= a.title;
    title.font_size=4;
    title.font_style=5;
    x_label=a.x_label;
    x_label.font_size= 3;
    y_label=a.y_label;
    y_label.font_size= 3;
endfunction





function draw_fullTank(h,open)
    
    scf(tank_fig_id);
    clf(tank_fig_id);
    plot2d(0,0,0,rect=[0,0,3,3],frameflag=3) 
    a = gca();
    a.tag                   = "plot";
    a.title.text            = "Récipient";
    a.title.font_size       = 5;
    a.axes_visible          = "off";
     draw_tank();
     draw_water(h);
     draw_water_pipe1();
       draw_water_pipe3();
     if open==1 then
         draw_water_pipe2(h);
         draw_water_pipe4();
     end    
endfunction






function draw_simulation(hoki,hi,residual,alarm_signal,index)
    drawlater();
    scf(sim_fig_id);
    create_simulation_plots();
    a = gca();
    subplot(3,1,1);
    if i>180 then
      plot(t,hoki,'g');
    end
    plot(t,hi); 
    subplot(3,1,2);
    resi=residual(index:index+50);
    alarm_signali=alarm_signal(index:index+50);
    plot(t,resi);
    subplot(3,1,3);
    plot(t,alarm_signali,'r');
    drawnow();
endfunction



         

function draw_tank()
    xset("color",color("black"));
     x1 = [1,1,1.45]';
    y1 = [1.5,0.5,0.5]';
    xpoly(x1,y1);
   
    x2 = [1.55,2,2]';
    y2 = [0.5,0.5,1.5]';
    xpoly(x2,y2);

    x3 = [0.5,1]';
    y3 = [2,2]';
    xpoly(x3,y3);
    
    x3 = [0.5,1]';
    y3 = [2.1,2.1]';
    xpoly(x3,y3);

    x4 = [1.2,1.5,1.5]';
    y4 = [2.1,2.1,1.6]';
    xpoly(x4,y4);

    x5 = [1.2,1.4,1.4]';
    y5 = [2,2,1.6]';
    xpoly(x5,y5);
  

    xarc(1,2.15,0.2,0.2,0,360*64);
    
    x6 = [1.45,1.45,1.8]';
    y6 = [0.5,0.2,0.2]';
    xpoly(x6,y6);
    
    x7 = [1.55,1.55,1.8]';
    y7 = [0.5,0.3,0.3]';
    xpoly(x7,y7);

    x8 = [2,2.3]';
    y8 = [0.3,0.3]';
    xpoly(x8,y8);

    x9 = [2,2.3]';
    y9 = [0.2,0.2]';
    xpoly(x9,y9);
    xarc(1.8,0.35,0.2,0.2,0,360*64);
endfunction

function draw_water(h)
    xset("color",color("lightskyblue"));
    xfrect(1.01,0.51+h,0.99,h);
endfunction


function draw_water_pipe1()
    xset("color",color("lightskyblue"));
    xfrect(0.5,2.09,0.50,0.09);
endfunction


function draw_water_pipe2(h)
    xset("color",color("lightskyblue"));
    xfrect(1.2,2.09,0.295,0.09);
    xfrect(1.405,2,0.09,2-(0.5+h));
endfunction

function draw_water_pipe3()
    xset("color",color("lightskyblue"));
    xfrect(1.455,0.52,0.09,0.31);
    xfrect(1.455,0.29,0.345,0.09);
endfunction

function draw_water_pipe4()
    xset("color",color("lightskyblue"));
    xfrect(2,0.29,0.3,0.09);
endfunction


function runSimulation()
    tank_fig = figure(tank_fig_id,"Figure_name","Récipient","BackgroundColor",[1,1,1],"layout", "border");
    sim_fig = figure(sim_fig_id,"Figure_name","Simulation","BackgroundColor",[1,1,1],"layout", "border");
    hok = simulate_system_ok();
    h = simulate_system_leak();
    clock=0:0.1:360;
    
    // observation of the input flow
    sensor_noise = 0.0005;
    noisegen(0.1, 360, sensor_noise);
    input_noise = feval(t,Noise);
    inflow_observation = 0:0.1:360;
    for i = 1:3601
      inflow_observation(i) = input_flow(clock(i)) + input_noise(i)
    end
    
    // observation of the output flow
    sensor_noise = 0.0006;
    noisegen(0.1, 360, sensor_noise);
    output_noise = feval(t,Noise);
    outflow_observation = 0:0.1:360;
    for i = 1:3601
      outflow_observation(i) = output_flow(i,h) + output_noise(i)
    end 
    
    //**********************************************************************
    // let us design the observer
    //**********************************************************************
    h_hat=0:0.1:360;
    h_dot_hat=0:0.1:360;
    h_hat(1)=0.3;
    h_dot_hat(1)=0;
    inflow_hat=0:0.1:360;
    outFlow_hat=0:0.1:360;
    residual=0:0.1:360;
    
    
    for i = 1:3600
      outFlow_hat(i) = c * h_hat(i);
      h_dot_hat(i+1) =inflow_observation(i)/A_r - c*h_hat(i)/A_r  ...
          + 0.01 * (outflow_observation(i) - outFlow_hat(i));
      h_hat(i+1)= h_hat(i) + 0.1 * h_dot_hat(i+1);
      residual(i) = outFlow_hat(i) - outflow_observation(i);
    end
    outFlow_hat(3601) = c * h_hat(3601);
    residual(3601) = outFlow_hat(3601) - outflow_observation(3601);
    inflow_hat(3601) = inflow_observation(3601)/A_r;
    alarm_signal = 0:0.1:360;
    for i = 1:3601
        if residual(i) < 0.002 then
        alarm_signal(i) = 0
    else
        alarm_signal(i) = 1
    end
end
    k=5;
    index = 1;
    for i = 0:k:340
        j=i+k;
        t=i:0.1:j;
        hi= h(index:index+50);
        hoki = hok(index:index+50);
        draw_simulation(hoki,hi,residual,alarm_signal,index);
        drawlater();
        draw_fullTank(h(index),1);
        index = index + 51;
        drawnow();
        sleep(500);
    end
endfunction



function main()
    demo_fds2014();
endfunction


main();

