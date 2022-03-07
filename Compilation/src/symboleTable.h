#ifndef __symoboleTable__
#define __symoboleTable__

#include "abstract-tree.h"

#define MAXDICO 3000

#define C_VARIABLE_GLOBALE 1
#define C_VARIABLE_LOCALE 2
#define C_ARGUMENT 3
#define T_ENTIER 1
#define T_CHARACTER 2
#define T_STRING 3
#define T_FONCTION 4
#define BUCKETNUM 1031

typedef enum {
	Global, Local, Fonction, Vide, Argument
}Classe;


typedef struct elem{
  char identifier[100];
  int pointeur;
  int lineno;
  int nombreArgument;
  int adresse;
  Classe classe;
  Kind type;
  struct elem *next;
} Elem , *Element;


typedef struct hachage{

  Elem *element_tableau;
  size_t ident;
  struct hachage *next;

} Tableau, *Hachage;


Hachage symbolTable (Node *tree, Element* redefError, Element* declError);

void printRedefErrTable(Element redefError);

void printfDeclErrTable (Element declError);

void printSymboleTable( Hachage symboleTable);

#endif
