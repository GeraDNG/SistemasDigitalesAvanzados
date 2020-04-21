
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name P21_Mustang_Tail_Lights_Controller_FSM -dir "C:/Users/Surface Pro/Desktop/Mustang Tail Lights Controller FSM/P21_Mustang_Tail_Lights_Controller_FSM/planAhead_run_3" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Surface Pro/Desktop/Mustang Tail Lights Controller FSM/P21_Mustang_Tail_Lights_Controller_FSM/Mustang_Tail_Lights_Controller.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Surface Pro/Desktop/Mustang Tail Lights Controller FSM/P21_Mustang_Tail_Lights_Controller_FSM} }
set_property target_constrs_file "Mustang_Tail_Lights_Controller.ucf" [current_fileset -constrset]
add_files [list {Mustang_Tail_Lights_Controller.ucf}] -fileset [get_property constrset [current_run]]
link_design
