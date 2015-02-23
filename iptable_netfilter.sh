#!/bin/bash

##################################################################
##	Rascunho para aula de Seg. S.O. e R.C. I		##
##	Ministradas pela professora Juliane			##	
##	Referências: Carlos E. Morimoto, Sevidores linux;	##
##		ianna.org; vivaolinux.com.br e focalinux	##
##	Autor: Eduardo Mendes					##
##	Data: 02/08/14						##
##	Licença: GPLv3						##
##################################################################

##	No caso de implentação de um script para o firewall
##	Podemos coloca-lo no /etc/rc.d/rc.<este script>		#No caso da minha distribuição, slackware essa seria a localização do script. No debian: /etc/init.d
##	E ao darmos permissão de excução para ele (chmod +x <este script>
##	Coloremos ele no rc.local ou em algum script de runlevel como rc5.d, da seguinte maneira:
##
##		if [ -x /etc/rc.d/rc.<este script> ]; then
##			/etc/rc.d/rc.<este script> start
##		fi

iniciar(){
#	Abre para a faixa de endereços locais
iptables -A INPUT -s <Faixa de endereço da sua rede>/<Sua sub-Rede> -j ACCEPT

#	Caso existam duas placas de rede, em NAT por exemplo
iptables -A INPUT -i <interface> -s <Faixa de endereço da sua rede>/<Sua sub-Rede> -j ACCEPT

#	Para abrir somente conexões TCP
#	Onde -p especifica o protocolo, poderiamos usar udp ou icmp
#	e --dpot a porta expecífica do protocolo, no caso (22 é SSH)
##	Para obter uma lista completa de portas, segue a refência do Ianna: http://www.iana.org/assignments/port-numbers
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#	Para ignorar pings na rede, o que pode deixa-la menos congestionada
#	No caso de usarmos algum tipo de mapeamento usando ping (Ping scan do Nmap). Dificulta saber quem está online
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

#	Quando fechamos TUDO, devemos, obrigatoriamente, deixar a interface de loopback aberta
#	O X11, junto do KDE, XFCE, GNOME ... Usa essa interface para se comunicar.
###	(Acho que eles utilizam sockets que passam pelo loopback) - Mas isso não é oficial
iptables -A INPUT -i lo -j ACCEPT

#	Para bloquear qualquer nova abertura de conexão, ou conexão com portas não expecificadas
#	Obs: Essa regra deve ser inserida após todas as regras de portas serem expecificadas
iptables -A INPUT -p tcp --syn -j DROP

##########################################################################
##	Aqui, a baixo, estão as regras para um proxy transparente	##
##	E também para usar o firewall como router			##
##	Optei por separar essa parte por não ser essêncial		##
##	No caso, nem todo firewall é proxy e/ou está em NAT		##
##########################################################################

#	Para compartilhar a conexão devemos ativar o módulo nat. Para saber mais sobre módulos: http://www.guiafoca.org/cgs/guia/intermediario/ch-kern.html
modproble iptable_nat

#	Devemos também ativar o roteamento no netfilter
echo 1 > /proc/sys/net/ipv4/ip_forward

#	Também devemos colocar o postrouting direcionando a nossa interface
iptables -t nat -A POSTROUNTING -o <interface de internet> -j MASQUERADE

#	Para criar um proxy transparente é só dirercionarmos todo o tráfego da porta 80 (web) para 3128 (proxy)
iptables -t nat -A PREROUTING -i <interface de rede> -p --tcp --dport 80 -j REDIRECT --to-port 3128

##########################################################################
##	Para entender as caracteristicas do DNAT e SNAT:		##
##	http://www.omnewall.com.br/recursos/nat.php 			##
##	A priori o DNAT é o NAT de destino e o SNAT é o de Origem	##
##########################################################################

#	Se tivermos um servidor interno atrás do firewall. Como exemplo um web server
##	Entrada
iptables -t nat -A PREROUTING -p tcp -i <interface externa> -m --multiport --port 80,443 -J DNAT --to <ip do servidor web na rede interna>
##	Saida
iptables -t nat -A POSROUTING -d <ip do servidor web na rede interna> -j SNAT --to <ip do firewall>

##################################################
##	Bloqueio de portas e endereços de saída	##
##	Da rede internet > externa		##
##################################################

#	Se usarmos output bloquearemos para todos os hosts da rede, icluindo o firewall
##	O range de portas 6881 -> 6889 corresponde as portas de torrent
###	Voltando ao site do Ianna: http://www.iana.org/assignments/port-numbers Lá podemos ver quais serviços rodam em quais portas
iptables -A OUTPUT -p tcp --dport 6881:6889 -j REJECTED

#	Se usarmos forward bloquearemos todos os hosts, mas não o firewall
iptables -A FORWARD -p tcp --dport 6881:6889 -j REJECTED

#	Podemos também bloquear um host específico
iptables -A FORWARD -p tcp --dport 6881:6889 -s <ip do host> -j REJECTED

#	Caso a rede seja baseada em DHCP, então podemos usar o MAC de um determinado host
iptables -A FORWARD -p tcp --dport 6881:6889 -m mac --mac-source <mac do host> -j REJECTED

#	Para bloquearmos um endereço específico
iptables -A FORWARD -d <link do site> -j REJECT

##################################################
##	Bloqueio de portas e endereços de saída	##
##	Da rede internet > externa		##
##						##
###	De preferência essas regras devem	##
###	Estar no início do scrip		##
###	Para evitar brechas logo de "cara"	##
##################################################

#	Para nos protegermos de Spoofing de IP, não faz parte exatamente do Iptables e sim do Netfilter de uma maneira geral.
#	Mas é bem útil na construção de um Script "seguro" de firewall
##	Caso queiram saber mais sobre o Netfilter: http://www.vivaolinux.com.br/artigo/NetFilter-Hook-em-Kernel-2.6 Um exelente artigo da comunidade
echo 1 > /pro/sys/net/ipv4/conf/default/rp_filter
##	Um apend ao rp_filter é que ele também forçar as requições a serem respondidas pela mesma interface em que elas foram feitas
iptables -A INPUT -m state --state INVALID -j DROP

#	Para evitar uma "leva" de pings, ou um ataque DoS, podemos limitar as respostas (nesse caso uma por segundo)
iptables -A INPUT -p icmp --icmp-type-echo-request -m limit --limit 1/s -j ACCEPT

#	Caso o seu servidor não atue como roteador, não faz sentindo deixar ativado o icmp redirect, recurso usado por roteadores para calclar uma melhor rota
##	Um bom link de refêrencia: http://linux-ip.net/html/routing-icmp.html
###	Vamos novamente usar diretamente o netfilter
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects

#	Podemos desativar também os pings de broadcast, também usados em ataques DoS
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

#	Para desativar o source routing
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route

#	Podemos evitar também o syn flood. O ataque de DoS mais simples de todos
##	O netflinter tem uma opção de cookies para SYN, assim o mesmo host não pode fazer mais de uma requisição de SYN por vez
echo 1 /proc/sys/net/ipv4/tcp_syncookies
}

parar(){

#	Remove todas as regras
	iptables -F

#	Altera a politica padrão
	iptables -P INPUT ACEEPT
	iptables -P OUTPUT ACEEPT

#	Limpa a tabela de NAT
	iptables -t nat -F

#	Garante que qualquer regra oculta seja eliminada

#	Desativa o roteamento no netfilter
echo 0 > /proc/sys/net/ipv4/ip_forward
}

listar(){

#	Lista as regras atuais do firewall
	iptables -L

#	Esse case usa a primeira flag do scrip
case $1 in
	"start") iniciar ;;
	"stop") parar ;;
	"restart") parar; iniciar;;
	"list") listar;;
	*) echo "Use parâmetros start, stop ou restart"
esac
