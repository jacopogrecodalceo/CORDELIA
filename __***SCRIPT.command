#!/bin/zsh

cd "$(dirname "$0")/_setting/_script"

for f in *.rb
	do
		if ruby "$f"; then
			echo "Script '$f' executed successfully."
		else
			echo "Error executing script '$f'."
			read -p "Press any key to continue..."
		fi
	done

echo "All scripts executed. Closing terminal..."
exit 0
