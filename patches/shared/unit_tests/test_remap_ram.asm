@asar 1.37

;;;;;;;;;;;
;UNIT TEST;
;;;;;;;;;;;

; Unit Test: RAM Remapping

incsrc ./../shared.asm


!num_tests_performed = 0
!num_tests_passed = 0


macro test_remap_function(function_name, in_address, expected_sa1_address)
	!num_tests_performed += +1
	
	!out_value = <function_name>(<in_address>)
	!passed = "FAILED"
	
if !use_sa1_mapping == 1
	!expected_value = <expected_sa1_address>
	if !out_value == !expected_value
		!num_tests_passed += +1
		!passed = "PASSED"
	endif
else
	!expected_value = <in_address>
	if !out_value == !expected_value
		!num_tests_passed += +1
		!passed = "PASSED"
	endif
endif

print "<function_name>(<in_address>) => $",hex(!out_value)," (expected: !expected_value) - !passed!"

endmacro


print "Unit Test: remap_ram()"
print ""
if !use_sa1_mapping == 1
	!sa1_mapping_string = "Yes"
else
	!sa1_mapping_string = "No"
endif
print "SA-1 ROM: !sa1_mapping_string"
print ""

; Test Start

; remap_sprite_table_ram()

%test_remap_function(remap_sprite_table_ram, $AA, $309E)
%test_remap_function(remap_sprite_table_ram, $00AA, $309E)
%test_remap_function(remap_sprite_table_ram, $7E00AA, $309E)
%test_remap_function(remap_sprite_table_ram, $B5, $30A9)
%test_remap_function(remap_sprite_table_ram, $9E, $3200)
%test_remap_function(remap_sprite_table_ram, $154C, $32DC)
%test_remap_function(remap_sprite_table_ram, $14EC, $74C8)

; remap_ram()

print ""

%test_remap_function(remap_ram, $19, $3019)
%test_remap_function(remap_ram, $0019, $3019)
%test_remap_function(remap_ram, $7E0019, $3019)
%test_remap_function(remap_ram, $AA, $309E)
%test_remap_function(remap_ram, $7E00AA, $309E)
%test_remap_function(remap_ram, $B5, $30A9)
%test_remap_function(remap_ram, $154C, $32DC)
%test_remap_function(remap_ram, $0100, $6100)
%test_remap_function(remap_ram, $1000, $7000)
%test_remap_function(remap_ram, $7EC800, $40C800)
%test_remap_function(remap_ram, $7FAB1C, $6056)


; Test End

print ""
print "Test finished."
print ""


if !num_tests_passed == !num_tests_performed
	!total_result = "All tests passed"
else
	if !num_tests_passed == 0
		!total_result = "All tests failed"
	else
		!total_result = "Some tests failed"
	endif
endif

print "Result: !total_result! (Passed tests: ",dec(!num_tests_passed)," out of ",dec(!num_tests_performed),")"
