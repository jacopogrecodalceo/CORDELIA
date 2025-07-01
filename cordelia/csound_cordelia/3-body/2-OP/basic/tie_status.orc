

    opcode tie_status, ii, 0

    itie tival

if (itie == 0 && p3 < 0) ithen
    ; this is an initial note within a group of tied notes
    istatus = 0
    
elseif (p3 < 0 && itie == 1) ithen
    ; this is a middle note within a group of tied notes 
    istatus = 1

elseif (p3 > 0 && itie == 1) ithen
    ; this is an end note out of a group of tied notes
    istatus = 2

elseif (p3 > 0 && itie == 0) ithen
    ; this note is a standalone note
    istatus = -1

endif  

    xout itie, istatus	

    endop

    