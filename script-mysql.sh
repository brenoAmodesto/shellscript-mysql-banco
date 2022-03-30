#!/bin/bash
##----------------------------------------------------------VARIÁVEIS-------------------------------------------------------------##

##----------------------------------------------------------VARIÁVEIS-------------------------------------------------------------##
echo1=$(echo -e "\e[34;1m Script Illimitar \e[m")
echo2=$(echo -e "\e[35;1m ------------------------ \e[m")
date=$(date +%H:%M:%S)
echo4=$(echo "Horário do servidor -> $date")
var=n
##---------------------------------------------------FUNCÕES----------------------------------------------------------------------##

##---------------------------------------------------FUNCÕES----------------------------------------------------------------------##

consulta_tabela(){ 
     while [ "$var" != "y" ]; do 
        echo -e "\e[32;1m Digite o nome do banco que deseja usar: \e[m "
        read banco

        echo -e "\e[34;1m Digite a tabela que deseja consultar: \e[m "
        read tabela

        echo -e "\e[36;1m Digite onde (where) id ou token etc\e[m"
        read onde
        
        echo -e "\e[36;1m Digite o id token etc"
        read arg

        mysql -u root -p!@A7v400mx -e "select * from $tabela where $onde = '$arg';" $banco  
        echo $?
     
        echo "Digite y para sair ou pressione enter para continuar"
        read var
   done
}

achar_conta(){
    echo "Digite o token"
    read token

    mysql -u root -p!@A7v400mx -e "select id_caixa from impressao_relacionamento where token ='$token' " illi > cat.txt

    var1=$( cat cat.txt | awk -F "id_caixa" '{print $1}' | grep -x -E '[[:digit:]]+' )

    mysql -u root -p!@A7v400mx -e "select data_abertura, data_fechamento, id_usuario, id_conta from caixa where id =$var1" illi
}

codigo_venda(){

   echo "Digite o token"
   read token
   ver1=$( echo "$token" | wc -m ) 
   echo "$teste" 

if [ "$ver1" = "37" ];
then 
   mysql -u root -p!@A7v400mx -e "select id, codigo, token from impressao_relacionamento where token='$token' " illi > codigo.txt
   codigo=$( cat codigo.txt | awk '{print $2}' | grep '[0-9]' )
   id=$( cat codigo.txt | awk '{print $1}' | grep '[[:digit:]]' )
   data=$( date )
   novocodigo=$( cat codigo.txt | awk 'NR==2 {print $2}' | grep '[0-9]' | sed -e 's#\(.\{14\}\)\(.*\)#\11\2#g' )
   ver2=$( echo "$codigo" | wc -m )    
else
   echo "Token errado"
fi


if [ "$ver2" = "16" ];
then
    echo "Este é o código -> $codigo"
    echo "Update feito as $data" >> codigo.txt
    echo "Este é o código antigo $codigo esse é o código novo $novocodigo" >> codigo.txt
    echo "Veja na nuvem se há um código igual, se sim, digite y para fazer um update caso contrário digite n"
    read afr
else 
    echo "Código errado"
fi


if [ "$afr" = "y" ];
then
   mysql -u root -p!@A7v400mx -e "update impressao_relacionamento set codigo='$novocodigo' where id='$id' " illi
   clear
   cat codigo.txt
else 
   echo "Exiting..."
fi

echo "Deseja desfazer update?  [y/n]"
read ver4

if [ "$ver4" = "y" ];
then
    mysql -u root -p!@A7v400mx -e "update impressao_relacionamento set codigo='$codigo' where id='$id' " illi
    clear
    echo "Exiting..... Succeed"
    echo "Update desfeito"
else
   echo "Exiting.."
fi

}

##---------------------------------------------------EXECUÇÃO----------------------------------------------------------------------##

##---------------------------------------------------EXECUÇÃO----------------------------------------------------------------------##


echo -e " $echo1 \n $echo2 \n $echo4 \n 1- Consultar tabela por id ou token \n 2- Achar usuario e conta do caixa \n 3- Codigo da venda ja cadastrado "
read var2

while test -n "$var2"
do 
   case "$var2" in
      1) consulta_tabela ;;
      2) achar_conta     ;; 
      3) codigo_venda    ;;
      *) exit 1          ;;
    esac
    shift
done