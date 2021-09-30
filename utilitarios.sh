#!/bin/bash

#Utilitarios para uso do Programa Principal

#Meus comentários:
#pega o que esta entre aspas, inclusive: "(.+?)"
#pega a abertura da tag <a>: <a href[^>]*.>
#cat -n cache/cache_links #mostra caminho dos links
#| sed -r 's/(<a href[^>]*.)(.+)<\/a.+/\2/g' #pega nome dos links em alt
#precisa tratar --- tratado
#read -p "Digite o endereço: " $link_acessado
#wget $link_acessado -O cache/paginaatual.html &>/dev/null
#echo $?
#read 
#caminho para o arquivo da pagina atual: cache/paginaatual.html




#FUNCAO EXIBIR PAGINA
#argumento $1: caminho do arquivo pagatual
function show_page (){  
  cat $1 | sed -r 's/$/ln/g' | tr '\n' '2' |sed 's/<[^>]*>//g' | sed -r 's/(\{.*body|body)(.\{|\{).*}//g' | sed 's/ln2/\n/g' | more
  read -p "Aperte qualquer tecla para continuar..."
}


#FUNCAO LISTAR LINKS
#argumento $1: caminho do arquivo pagatual
function link_list (){  
  cat $1 | grep -Eo '<a href[^>]*.>' > cache/tmp
  cat cache/tmp | sed -r 's/.*href=//g' | tr '>' ' ' | tr '"' ' '> cache/cache_links
  #echo -e '   NUM   LINK'
  cat cache/cache_links | more
  rm cache/tmp #cache/cache_links &> /dev/null
}


#FUNCAO ACESSAR LINKS
#argumento $1: caminho do arquivo pagatual; $2: link acessado
function access_link (){ 
  clear
  echo -e "LINKS NA PAGINA: \n"
  link_list $1
  read -p "Digite o endereço do link: " opc
  index=0
  while read linha; do  
    let index=index+1
    if [ $linha = $opc ]; then 
      linha_formatada=$(echo $linha | sed -r 's/(http+)(.+)/\1/g' ) #'
      #echo $linha_formatada
      if [ $linha_formatada = "http" ]; then
        echo "Acessando: $linha"
        wget $(echo "$linha") -O cache/paginaatual.html &>/dev/null
        link_acessado=$(echo $linha)
        #echo link_acessado
      else
        echo "Acessando: $2$linha"
        wget $(echo "$2$linha") -O cache/paginaatual.html &>/dev/null
        #link_acessado=$(echo $2$linha)
      fi
    fi
  done < cache/cache_links
}


#FUNCAO LISTAR IMAGENS
#argumento $1: caminho do arquivo pagatual;
function img_list (){
  cat $1 | grep -Eo '<img(.+?)>' > cache/tmp_img
  cat cache/tmp_img | grep -Eo '(src=)"([^"]*)"' | sed -r 's/src=//g'> cache/cache_img
  cat cache/cache_img | tr '"' ' ' > cache/cache_img1

  #echo -e '   NUM   LINK'
  #cat cache/tmp_img | grep -Eo '(src=)"([^"]*)"' | sed -r 's/src=//g' > cache/tmp_img1
  echo -e "Endereços de imagens na página: "
  cat cache/cache_img1
  rm cache/tmp_img cache/cache_img #cache/tmp_img1 #cache/cache_img1  
}


#FUNCAO BAIXAR IMAGENS
#argumento $1: caminho do arquivo pagatual; $2: link acessado
function img_down (){
  clear
  img_list $1
  echo
  read -p "Digite o endereço da imagem: " opc
  #index=0
  while read linha; do  
    #let index=index+1
    if [ $linha = $opc ]; then
      linha_formatada=$(echo $linha | sed -r 's/(http+)(.+)/\1/g' ) #'
      if [ $linha_formatada = "http" ]; then
        echo "Baixando: $linha"
        wget $(echo "$linha") &>/dev/null
      else
        echo "Baixando: $2$linha"
        wget $(echo "$2$linha") &>/dev/null
      fi
    fi
  done < cache/cache_img1
}


##FUNCAO ACESSAR OUTRO SITE
function other_link () {
  read -p "Digite outro endereço: " link_acessado
  wget $link_acessado -O cache/paginaatual.html &>/dev/null
  while [ $? -ne 0 ];do
    echo -e "ERRO: Não foi possível acessar essa página, digite outro endereço."
    read -p "Endereço do site: " link_acessado
    wget $link_acessado -O cache/paginaatual.html &>/dev/null
  done
}

#link_list cache/paginaatual.html      #teste listar links
#access_link cache/paginaatual.html kisslinux.org #testar acesso
