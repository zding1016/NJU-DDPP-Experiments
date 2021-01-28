transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/44254/Desktop/digit_design_exp/exp8_0 {C:/Users/44254/Desktop/digit_design_exp/exp8_0/exp8_0.v}

vlog -vlog01compat -work work +incdir+C:/Users/44254/Desktop/digit_design_exp/exp8_0/simulation/modelsim {C:/Users/44254/Desktop/digit_design_exp/exp8_0/simulation/modelsim/exp8_0.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  exp8_0_vlg_tst

add wave *
view structure
view signals
run -all
