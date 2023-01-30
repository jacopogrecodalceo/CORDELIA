function main()

    reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

    ret, value_input = reaper.GetUserInputs('Opcode', 1, 'Opcode:, extrawidth=350', '')

	if ret then

		reaper.ShowConsoleMsg(lines)

	end

	reaper.Undo_EndBlock('Insert env', 0) -- End of the undo block. Leave it at the bottom of your main function.

end

main() -- Execute your main function

reaper.UpdateArrange() -- Update the arrangement (often needed)

