
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboleTable.h"

static const char *StringFromEnum[] = {
	"Global", 
	"Local", 
	"Fonction", 
	"Vide",
	"Argument"
};

static const char *StringFromKind[] = {
  "Program",
  "VarDeclList",
  "VarDec",
  "FuncDecList",
  "FuncDec",
  "ArgList",
  "Pointer",
  "ParamList",
  "Param",
  "Body",
  "StmtList",
  "Return",
  "Add",
  "Sub",
  "Mult",
  "Div",
  "Mod",
  "Assign",
  "Or",
  "And",
  "Equal",
  "Different",
  "Inf",
  "Sup",
  "InfOrEq",
  "SupOrEq",
  "IntLiteral",
  "CharLiteral",
  "Identifier",
  "Decl",
  "Int",
  "Char",
  "Void",
  "Adress",
  "Opposite",
  "ReadE",
  "ReadC",
  "Print",
  "While",
  "If",
  "Else",
  "Positif",
  "Negatif",
  "Error",
  "ValueOf"

  /* and all other node labels */
  /* The list must coincide with the enum in abstract-tree.h */
  /* To avoid listing them twice, see https://stackoverflow.com/a/10966395 */
};

static size_t hash(const char *string) {
  size_t h = 0;
  for (const char *p = string; *p != '\0'; p++) {
    h = h * 31 + *p;
  }
  return h % BUCKETNUM;
}

static Tableau* addToSymbolTable( Kind symoleKind){

	Tableau *tmp = (Tableau *) malloc(sizeof(Tableau));
	if(tmp == NULL){
		return NULL;
	}
	tmp->next = NULL;
	tmp->element_tableau = NULL;
	tmp->ident = hash(StringFromKind[symoleKind]);
	
	return tmp;
}

static void ajouterElement(Node *node, Element *symboleTable, Classe classe, Kind type, int pointeur, int nbrArg){

	Element tmp = (Element) malloc(sizeof(Elem)), tmp_table = *symboleTable ;
	int adresse;
	tmp->next = NULL;
	tmp->pointeur = pointeur;
	tmp->classe = classe;
	tmp->nombreArgument = nbrArg;
	tmp->type = type;
	tmp->lineno = node->lineno;
	strcpy(tmp->identifier, node->u.identifier);
	if(*symboleTable == NULL){
		if(classe == Global)
			
			tmp->adresse = 8;
		else if(classe == Fonction)
			tmp->adresse = 0;
		else
			tmp->adresse = -8;
		*symboleTable = tmp;
	}	
	else{
		adresse = tmp_table->adresse;
		while (tmp_table->next != NULL){
	  		tmp_table = tmp_table->next;
	  		adresse = tmp_table->adresse;
		}
		if(classe == Global)
			tmp->adresse = adresse + (8*(pointeur+1));
		else if(classe == Fonction)
			tmp->adresse = 0;
		else
			tmp->adresse = adresse - 8;
		tmp_table->next = tmp;
	}
}

static int check_list_redefiniton(Element list, Node *childDeclared ){
	Element tmp = list;
	while(tmp !=NULL){
		if(strcmp(childDeclared->u.identifier, tmp->identifier) == 0){
			return 1;
		}
		tmp = tmp->next;
	} 
	return 0;
}

static int check_fct_names(Hachage fullTable ,Node *tmp_child){
	
	Tableau* tmp= (Tableau *)malloc(sizeof(Tableau));
	for ( tmp = fullTable;tmp != NULL ; tmp = tmp->next)
	{
		if(tmp->element_tableau != NULL && tmp->element_tableau->classe == Fonction && strcmp(tmp->element_tableau->identifier, tmp_child->u.identifier) == 0){
			return 1;
		}
	}
	return 0;
}

static void parseArbreVarDeclList( Node *tree, Element *symboleTable, Classe classe, Element *redefError, Element global_elems){

	int pointeur = 0;
	int index = 0;
	for (Node *childType = tree->firstChild; childType != NULL; childType = childType->nextSibling) {
		for (Node *varDec =childType->firstChild; varDec != NULL; varDec = varDec-> nextSibling){	
			for (Node *childVarDec =varDec->firstChild; childVarDec != NULL; childVarDec = childVarDec-> nextSibling,  index++){
				if(childVarDec->kind == Pointer)
					pointeur = 1;
				if( childVarDec->kind == Identifier){
					if (check_list_redefiniton(global_elems, childVarDec) || check_list_redefiniton(*symboleTable, childVarDec)){
						ajouterElement(childVarDec, redefError, classe, childType->kind, pointeur, 0);
					}
					ajouterElement(childVarDec, symboleTable, classe, childType->kind, pointeur, 0);
					pointeur = 0;
				}
			}
		}
	}
}

static void parseParamFonc(Node *tree, Hachage *symboleTable, Element *redefError){

	if(tree == NULL)
		return; 
	for(Node *tmp_sibling = tree; tmp_sibling != NULL; tmp_sibling = tmp_sibling->nextSibling){

		if(FIRSTCHILD(tmp_sibling)->kind == Pointer){
			if (check_list_redefiniton((*symboleTable)->element_tableau, FIRSTCHILD(tmp_sibling)->firstChild->nextSibling)){
				ajouterElement(FIRSTCHILD(tmp_sibling)->firstChild->nextSibling, redefError, Argument, FIRSTCHILD(tmp_sibling)->firstChild->kind, 1, 0);
			}
			ajouterElement(FIRSTCHILD(tmp_sibling)->firstChild->nextSibling, &(*symboleTable)->element_tableau, Argument, FIRSTCHILD(tmp_sibling)->firstChild->kind, 1, 0);	

		}
		else{
			if (check_list_redefiniton((*symboleTable)->element_tableau, FIRSTCHILD(tmp_sibling)->firstChild)){
				ajouterElement(FIRSTCHILD(tmp_sibling)->firstChild, redefError, Argument, FIRSTCHILD(tmp_sibling)->firstChild->kind, 0, 0);
			}
			ajouterElement(FIRSTCHILD(tmp_sibling)->firstChild, &(*symboleTable)->element_tableau, Argument, FIRSTCHILD(tmp_sibling)->kind, 0, 0);

		}
	}
}

static void parseEnTeteFonc(Node *tree, Hachage *symboleTable, Element *redefError){

	int nbrArg = 0;
	for(Node *tmp_sibling = THIRDCHILD(tree)->firstChild; tmp_sibling != NULL; tmp_sibling = tmp_sibling->nextSibling)
		nbrArg += 1;
	ajouterElement(SECONDCHILD(tree), &(*symboleTable)->element_tableau, Fonction, FIRSTCHILD(tree)->kind, 0, nbrArg);
	parseParamFonc(THIRDCHILD(tree)->firstChild, symboleTable, redefError);
}

static void parseArbreStmtList(Node *node, Element *symboleTable, Element *declError, Element global_elems, Hachage fullTable ){
	if(node == NULL){
		return;
	}
	for(Node *tmp_child = node->firstChild; tmp_child != NULL; tmp_child = tmp_child->nextSibling){
		if(tmp_child->kind == Identifier){
			if(check_list_redefiniton(global_elems, tmp_child) == 0 && check_list_redefiniton(*symboleTable, tmp_child)==0 
				&& check_fct_names(fullTable ,tmp_child) == 0  ){ // et symboleTable
				if (node->kind == Pointer)
					ajouterElement(tmp_child, declError, Local, tmp_child->kind, 1, 0);
				else
					ajouterElement(tmp_child, declError, Local, tmp_child->kind, 0, 0);
			}
		}
		parseArbreStmtList(tmp_child, symboleTable, declError, global_elems, fullTable );
	}
}

static void parseCorpsFonc(Node *tree, Hachage *symboleTable, Element *redefError, Element *declError, Element global_elems, Hachage fullTable){
	if(tree == NULL){
		return;
	}

	for(Node *tmp_sibling = tree; tmp_sibling != NULL; tmp_sibling = tmp_sibling->nextSibling){
		//printf("%s\n",  StringFromKind[tmp_sibling->kind]);
			if (tmp_sibling->kind == VarDeclList){
				//*symboleTable = addToSymbolTable(VarDeclList);
		 		parseArbreVarDeclList(tmp_sibling, &(*symboleTable)->element_tableau, Local, redefError, global_elems); 
			}else if (tmp_sibling->kind == StmtList){
				parseArbreStmtList(tmp_sibling, &(*symboleTable)->element_tableau, declError, global_elems, fullTable );
			}
			else
				parseCorpsFonc( tmp_sibling->firstChild, symboleTable, redefError, declError, global_elems, fullTable);
		}
}

static void parseArbreFuncDec( Node *tree, Hachage *symboleTable, Element *redefError,  Element *declError, Element global_elems, Hachage fullTable){
	
	parseEnTeteFonc(tree, symboleTable, redefError);
	parseCorpsFonc(THIRDCHILD(tree)->nextSibling, symboleTable, redefError, declError, global_elems, fullTable);	
}

static void parseArbreFuncDeclList(Node *tree, Hachage *symboleTable, Element *redefError, Element *declError, Element global_elems){

	Hachage tmp2 = *symboleTable, tmp = NULL;;
	for(Node *tmp_sibling = tree->firstChild; tmp_sibling != NULL; tmp_sibling = tmp_sibling->nextSibling){
		tmp = tmp2;
		tmp->next = addToSymbolTable(FuncDec);
		parseArbreFuncDec(tmp_sibling, &(tmp)->next, redefError, declError, global_elems, *symboleTable);
		tmp2 = tmp->next;
	}
}

static void parse(Node *tree, Hachage *symboleTable, Element *redefError, Element *declError){
	Element global_elems = NULL;
	for(Node *tmp_child = tree; tmp_child != NULL; tmp_child = tmp_child->firstChild){
		for(Node *tmp_sibling = tmp_child; tmp_sibling != NULL; tmp_sibling = tmp_sibling->nextSibling){
			if (tmp_sibling->kind == VarDeclList && FIRSTCHILD(tmp_sibling) != NULL){
				*symboleTable = addToSymbolTable(VarDeclList);
		 		parseArbreVarDeclList(tmp_sibling, &(*symboleTable)->element_tableau, Global, redefError, global_elems);
		 		//if(FIRSTCHILD(tmp_sibling) != NULL)
		 			global_elems = (*symboleTable)->element_tableau;
			}
			else if(tmp_sibling->kind == FuncDecList){
				if(*symboleTable == NULL)
					*symboleTable = addToSymbolTable(FuncDecList);
				else
					(*symboleTable)->next = addToSymbolTable(FuncDecList);
		 		parseArbreFuncDeclList(tmp_sibling, symboleTable, redefError, declError, global_elems);
			}
		}
	}
}

Hachage symbolTable (Node *tree, Element* redefError, Element *declError){
	Hachage symboleTable = NULL;

	parse(tree, &symboleTable, redefError, declError);

	return symboleTable;
}


void printRedefErrTable(Element redefError){
	//printf("\n%60s\n\n", "redefined variables ");
	//printf("%s %21s %15s %15s %15s %15s %15s\n\n", " ", "Classe", "name", "line", "type", "pointeur", "nbr arg");
	for(Elem* tmp =redefError; tmp != NULL; tmp = tmp->next){
		printf("\033[0;31mError: \033[0mla variable %s à la ligne %d est déja été déclarée\n", tmp->identifier, tmp->lineno);
		//printf("%*s %s %*.*s %*d %*.*s %*d %*d\n",15," ", StringFromEnum[tmp->classe],15,15, tmp->identifier, 15, tmp->lineno ,15,15, StringFromKind[tmp->type], 15,tmp->pointeur, 15, tmp->nombreArgument );
		
	}
}

void printfDeclErrTable (Element declError){
	//printf("\n%60s\n\n", "undeclared variables ");
	//printf("%s %21s %15s %15s %15s %15s %15s\n\n", " ", "Classe", "name", "line", "type", "pointeur", "nbr arg");
	for(Elem* tmp =declError; tmp != NULL; tmp = tmp->next){
		printf("\033[0;31mErreur: \033[0mla variable %s à la ligne %d est utilisée mais pas déclarée\n", tmp->identifier, tmp->lineno);
		//printf("%*s %s %*.*s %*d %*.*s %*d %*d\n", 15, " ",StringFromEnum[tmp->classe],15,15, tmp->identifier, 15, tmp->lineno ,15,15, StringFromKind[tmp->type], 15,tmp->pointeur, 15, tmp->nombreArgument );
	}
}

void printSymboleTable( Hachage symboleTable){

	Hachage tmp;
	int cpt = 0;

	printf("\n%60s\n\n", "synbole table ");
	printf("%s %15s %15s %15s %15s %15s %15s %15s\n","Niveau", "Classe", "name", "lineno", "type", "pointeur", "nbr arg", "adresse");
	for (; tmp != NULL; tmp = tmp->next, cpt++) {
		printf("%d\n", cpt);
	 	Elem* args = tmp->element_tableau;

	 	for (; args != NULL; args = args->next){	
	 		printf("%*.*s %*s %*d %*s %*d %*d %*d\n",22,15, StringFromEnum[args->classe],15, args->identifier, 15, args->lineno,15, StringFromKind[args->type], 15,args->pointeur, 15, args->nombreArgument, 15, args->adresse );
	 	}
	}
}
