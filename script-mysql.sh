#!/bin/bash
echo -e "\e[34;1m Script MySQL \e[m"
echo -e "\e[35;1m ------------------------ \e[m"

echo -e " 1- Consultar tabela por id ou token \n 2- Achar usuario e conta do caixa \n 3- Codigo da venda ja cadastrado "
read var2

#Consultar tabela

consulta_tabela(){
var=n 
     while [ "$var" != "y" ]; do 
        echo -e "\e[32;1m Digite o nome do banco que deseja usar: \e[m "
        read banco

        echo -e "\e[34;1m Digite a tabela que deseja consultar: \e[m "
        read tabela

        #if [ "$tabela" = "impressao_relacionamento" ]
        #then
        #     echo "Essa tabela contêm a coluna token"
        #fi
        
        echo -e "\e[36;1m Digite onde (where) id ou token etc\e[m"
        read onde
        
        echo -e "\e[36;1m Digite o id token etc"
        read arg

        mysql -u root -psenhabanco -e "select * from $tabela where $onde = '$arg';" $banco  
        echo $?
     
        echo "Digite y para sair ou pressione enter para continuar"
        read var
   done
}

#Achar usuario e conta

achar_conta(){
    echo "Digite o token"
    read token

    mysql -u root -psenhabanco -e "select id_caixa from impressao_relacionamento where token ='$token' " banco > cat.txt

    var1=$( cat cat.txt | awk -F "id_caixa" '{print $1}' | grep -x -E '[[:digit:]]+' )

    mysql -u root -psenhabanco -e "select data_abertura, data_fechamento, id_usuario, id_conta from caixa where id =$var1" banco
}

#Codigo da venda já existente

codigo_venda(){

   echo "Digite o token"
   read token
   char=$( echo "$token" | wc -m ) 
   echo "$char" 
if [ "$char" = "37" ];
then 
   mysql -u root -p!@A7v400mx -e "select id, codigo, token from impressao_relacionamento where token='$token' " banco > codigo.txt
   codigo=$( cat codigo.txt | awk '{print $2}' | grep '[0-9]' )
   id=$( cat codigo.txt | awk '{print $1}' | grep '[[:digit:]]' )
   #random=$( echo $(( $RANDOM % 9 )) )
   data=$( date )
   novocodigo=$( cat codigo.txt | awk 'NR==2 {print $2}' | grep '[0-9]' | sed -e 's#\(.\{14\}\)\(.*\)#\11\2#g' )
   
   #echo "$random aleatorio" 
   echo "Este é o código -> $codigo"
   #echo "$novocodigo"
   echo "Update feito as $data" >> codigo.txt
   echo "Este é o código antigo $codigo esse é o código novo $novocodigo" >> codigo.txt
   echo "Veja na nuvem se há um código igual, se sim, digite y para fazer um update caso contrário digite n"
   read afr


   if [ "$afr" = "y" ];
   then
       mysql -u root -psenhabanco -e "update impressao_relacionamento set codigo='$novocodigo' where id='$id' " banco
   else
      echo "Exiting.."
   fi

   clear
   cat codigo.txt
else
   echo -e "Token Errado"
fi
}


if [ "$var2" == "1" ];
then
    consulta_tabela  
elif [ "$var2" == "2" ];
then
     achar_conta
elif [ "$var2" == "3" ];
then
     codigo_venda
fi
