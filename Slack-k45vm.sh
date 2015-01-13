#!/bin/bash
	#
	#	Esse programa executa a pós-instação do Slackware 14.1(XFCE)
	#	No computador Asus k45vm - GeForce 630M 2GB
	#	
	#	Serão feitas instalações de programas necessários como Bumblebee, XFBurn, LapTopMode
	#
	#	E algumas de minha preferência como Clementine e suas libs para IPOD, Sublime text etc...
	#
	#	Para ver a lista completa de programas coloque o parametro -P
	#
	#	Para instalar em outro modelo de computador (que não o asus específico) use a flag -not-k45vm
	#
	#	Para instalar o modo completo, como instalo no meu computador use a flag -full
	#
	#	Para instalar somente algumas coisas use o -menu

###################		Mensagens		######################

	# -P
	LISTA_COMPLETA="

	###		Lista completa dos programas		###

		Acessórios:
					Sublime Text Editor
					Visualizador de imagens
					Xfburn

		Desenvolvimento:
					Anjunta
					Arduino IDE
					Open-JDK

		Escritório:

					Master PDF Editor
					OpenOffice

		Internet:
					Pidgin
					Transmission
					WICD

		Multimídia:
					Clementine
					VLC

		Sistema:
					VirtualBox	

		Placa de vídeo:
					bbswitch
					Bumblebee
					libbsd
					libjpeg
					libvdpau
					Nvidia-Bumblebee
					Nvidia-Kernel
					VirtualGL
	"

	# -not-k45vm

	NOT_K45VM="

	###		Você escolheu -not-k45vm		###

		A instalação será proxima a instalação FULL, mas não instalaremos:

			- LapTopMode
			- Bumblebee

	"

	# -full

	FULL="

	###		Você escolheu FULL, logo a instalação conterá todos os pacotes listados na flag -P 			###
		
	"

	# -menu

	MENU="

	###		Você escolheu MENU, logo antes de toda instalação lhe perguntaremos se aceita o software proposto		###

	"
	AJUDA="

	#	Esse programa executa a pós-instação do Slackware 14.1(XFCE)
	#	No computador Asus k45vm
	#	
	#	Serão feitas instalações de programas necessários como Bumblebee, XFBurn, LapTopMode
	#
	#	E algumas de minha preferência como Clementine e suas libs para IPOD, Sublime text etc...
	#
	#	Para ver a lista completa de programas coloque o parametro -P
	#
	#	Para instalar em outro modelo de computador (que não o asus específico) use a flag -not-k45vm
	#
	#	Para instalar o modo completo, como instalo no meu computador use a flag -full
	#
	#	Para instalar somente algumas coisas use o -menu

	"
###################		Código			######################

	case "$1" in 

		-P)
			echo "$LISTA_COMPLETA"
			exit 0
		;;

		-not-k45vm)
			echo "$NOT_K45VM"
			cnot="1"
		;;

		-full)
			echo "$FULL"
			cfull="1"
		;;

		-menu)
			echo "$MENU"
			cmenu="1"
		;;

		-h) 
			echo "$AJUDA"
			exit 0
		;; 
		*)
			echo "Flag inválida"
			exit 0
	esac

	if [ $cfull="1" ]; then
	echo""

	elif [ $cnot="1" ]; then
	echo""

	elif [ $cmenu="1" ]; then
	echo""

	fi
