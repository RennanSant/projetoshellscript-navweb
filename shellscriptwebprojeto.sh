#!/bin/bash

#Projeto de: Rennan Santiago Costa
#Navegador Shell Script
#Funções do programa: Exibir Página, Lista de Links, Acessar Link, Lista de Imagens, Baixar Imagem

#Sites teste:
#https://37signals.com/
#man.he.net
#http://info.cern.ch/hypertext/WWW/TheProject.html

source utilitarios.sh
mkdir cache &>/dev/null

if [ -z $1 ]; then
  read -p "Endereço do site: " link_acessado
  wget $link_acessado -O cache/paginaatual.html &>/dev/null
  while [ $? -ne 0 ];do
    echo -e "ERRO: Não foi possível acessar essa página, digite outro endereço."
    read -p "Endereço do site: " link_acessado
    wget $link_acessado -O cache/paginaatual.html &>/dev/null
  done
else
  link_acessado=$1
  wget $link_acessado -O cache/paginaatual.html &>/dev/null
  while [ $? -ne 0 ];do
    echo -e "ERRO: Não foi possível acessar essa página, digite outro endereço."
    read -p "Endereço do site: " link_acessado
    wget $link_acessado -O cache/paginaatual.html &>/dev/null
  done
fi


while true;do
  clear
  echo -e "\n\n-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
  echo -e "-=-=--=-=-=-=-=-=-NAVEGADOR SHELL=-=-=-=-=-=-=-="
  echo -e "-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n"
  echo -e "\nAcessando: $link_acessado \n"
  echo -e "Opções: "
  echo -e "1) Exibir página"
  echo -e "2) Lista de links"
  echo -e "3) Acessar link"
  echo -e "4) Lista de imagens"
  echo -e "5) Baixar imagem"
  echo -e "6) Acessar outra página"
  echo -e "7) Apagar cache do navegador"
  echo -e "q) Sair \n"
  
  read -p "OPÇÃO: " opc

  case $opc in 
    1) show_page cache/paginaatual.html ;;
    2) link_list cache/paginaatual.html ; read -p "Pressione qualquer tecla para continuar...";;
    3) access_link cache/paginaatual.html $link_acessado ; read -p "Pressione qualquer tecla para continuar...";;
    4) img_list cache/paginaatual.html ; read -p "Pressione qualquer tecla para continuar...";;
    5) img_down cache/paginaatual.html $link_acessado ; read -p "Pressione qualquer tecla para continuar...";;
    6) other_link ;;
    7) echo "Apagando cache..."; rm cache/cache* &> /dev/null; read -p "Cache apagado. Pressione qualquer tecla para continuar..." ;;
    'q') break ;;
    *) echo -e 'ERRO: Opção não existe. \n'; read -p "Pressione qualquer tecla para continuar...";;
  esac
done

    