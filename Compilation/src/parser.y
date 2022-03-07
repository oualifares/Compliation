%{
/* tpc-2019-2020.y */
/* Syntaxe du TPC pour le projet d'analyse syntaxique de 2019-2020*/
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int yylex();
int parse = 0;
int result;
void yyerror(char *s);

extern int lineno;
extern int charno;
%}

%code requires {
    #include "writeNasm.h"
    //#include "symboleTable.h"
    //#include "typeSymboleTable.h"
}


%union{
    char error[64];
    char ident[64]; 
    char type[5];
    char order[3];
    char equal[3];
    char signe;
    char character;
    int integer;
    Node *node;
}


%{
    Node *abstractTree = NULL;
%}



%token <type> TYPE
%token <ident> IDENT
%token VOID
%token READE
%token READC
%token PRINT
%token IF
%nonassoc "then"
%nonassoc ELSE
%token WHILE
%token RETURN

%token OR
%token AND
%token EQ
%token <order> ORDER
%token <signe> ADDSUB
%token <integer> NUM
%token <character> CHARACTER

%type <node> DeclVars Declarateurs DeclFoncts DeclFonct EnTeteFonct Parametres ListTypVar Corps SuiteInstr Instr LValue Exp TB FB M E T F Arguments ListExp 
%type <node> Prog

%%
Prog: DeclVars DeclFoncts               {
                                         $$ = makeNode(Program); 
                                        addChild($$, $1); 
                                        Node *listFonc = makeNode(FuncDecList); addChild(listFonc, $2);
                                        addChild($$, listFonc); abstractTree = $$;}
    ;

DeclVars:
       DeclVars TYPE Declarateurs ';'   {

                                         Node *tmp;
                                         if(!strcmp($<type>2, "int")){tmp = makeNode(Int);};
                                         if(!strcmp($<type>2, "char")){tmp = makeNode(Char);};
                                         addChild($$, tmp);
                                         addChild(tmp, $3);
                                         $$ = $1;
                                        }
    |                                   {$$ = makeNode(VarDeclList);};

Declarateurs:
       Declarateurs ',' IDENT           {
                                         Node *tmp_node = makeNode(VarDec);
                                         Node *tmp_ident = makeNode(Identifier); 
                                         addSibling($$, tmp_node);
                                         addChild(tmp_node,tmp_ident);
                                         strcpy(tmp_ident->u.identifier,$3);
                                         }
    |  Declarateurs ',' '*' IDENT       {Node *tmp_node = makeNode(VarDec);
                                         Node *tmp = makeNode(Pointer);
                                         Node *tmp_ident = makeNode(Identifier); 
                                         addSibling(tmp, tmp_ident);
                                         addSibling($$, tmp_node);
                                         addChild(tmp_node,tmp);
                                         strcpy(tmp_ident->u.identifier,$4);                                         
                                        } 
    |  IDENT                            {$$ = makeNode(VarDec); Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$1); addChild($$,tmp);}
    |  '*' IDENT                        {$$ = makeNode(VarDec); Node *tmp_node = makeNode(Identifier); Node *tmp = makeNode(Pointer); strcpy(tmp_node->u.identifier,$2); addSibling(tmp, tmp_node); addChild($$,tmp);}
    ;

DeclFoncts:
       DeclFoncts DeclFonct             {$$ = $1; addSibling($1, $2);}
    |  DeclFonct                        {$$ = $1;}
    |  error                            {$$ = makeNode(Error); yyclearin;} 
    ;

DeclFonct:
       EnTeteFonct Corps                {$$ = makeNode(FuncDec); addChild($$, $1); addChild($$, $2);}
    ;
     
EnTeteFonct:
       TYPE IDENT '(' Parametres ')'    {if(!strcmp($<type>1, "int")){$$ = makeNode(Int);};
                                         if(!strcmp($<type>1, "char")){$$ = makeNode(Char);};
                                         Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$2); 
                                         addSibling($$, tmp);
                                         addSibling($$, $4);
                                        }
    |  TYPE '*' IDENT '(' Parametres ')'    {$$ = makeNode(Pointer);
                                             if(!strcmp($<type>1, "int")){addChild($$, makeNode(Int));};
                                             if(!strcmp($<type>1, "char")){addChild($$, makeNode(Char));};
                                             Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$3); 
                                             addSibling($$, tmp);
                                             addSibling($$, $5);}
    |  VOID IDENT '(' Parametres ')'    {$$ = makeNode(Void);
                                         Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$2); 
                                         addSibling($$, tmp);
                                         addSibling($$, $4);}
    |  error                            {$$ = makeNode(Error); yyclearin;}
    ;

Parametres:
       VOID                             {$$ = makeNode(ParamList);}               
    |  ListTypVar                       {$$ = makeNode(ParamList); addChild($$, $1); }
    ;

ListTypVar:
       ListTypVar ',' TYPE IDENT        {Node *res = makeNode(Param);
                                         Node *tmp_type = NULL;
                                         if(!strcmp($<type>3, "int")){tmp_type = makeNode(Int);};
                                         if(!strcmp($<type>3, "char")){tmp_type = makeNode(Char);};
                                         Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$4);
                                         addChild(tmp_type, tmp);
                                         addChild(res, tmp_type);
                                         addSibling($1, res);
                                         $$ = $1;}
    |  ListTypVar ',' TYPE '*' IDENT    {Node *res = makeNode(Param);
                                         Node *tmp_type = makeNode(Pointer);
                                         if(!strcmp($<type>3, "int")){addChild(tmp_type,makeNode(Int));};
                                         if(!strcmp($<type>3, "char")){addChild(tmp_type,makeNode(Char));};
                                         Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$5);
                                         addChild(tmp_type, tmp);
                                         addChild(res, tmp_type);
                                         addSibling($1, res);
                                         $$ = $1;}
    |  TYPE IDENT                       {$$ = makeNode(Param);
                                         Node *tmp_type = NULL;
                                         if(!strcmp($<type>1, "int")){tmp_type = makeNode(Int);};
                                         if(!strcmp($<type>1, "char")){tmp_type = makeNode(Char);};
                                         Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$2);
                                         addChild(tmp_type, tmp);
                                         addChild($$, tmp_type);
                                         }
    |  TYPE '*' IDENT                   {$$ = makeNode(Param);
                                         Node *tmp_type = makeNode(Pointer);
                                         if(!strcmp($<type>1, "int")){addChild(tmp_type,makeNode(Int));};
                                         if(!strcmp($<type>1, "char")){addChild(tmp_type,makeNode(Char));};
                                         Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$3);
                                         addChild(tmp_type, tmp);
                                         addChild($$, tmp_type);}
    |  error                            {$$ = makeNode(Error); yyclearin;}
    ;

Corps: '{' DeclVars SuiteInstr '}'      {$$ = makeNode(Body); addChild($$, $2); addChild($$, $3);}
    ;

SuiteInstr:
       SuiteInstr Instr                 {if($1->kind == StmtList){
                                            addChild($$, $2);}
                                        }
    |                                   {$$ = makeNode(StmtList);}
    ;

Instr:
       LValue '=' Exp ';'               {$$= makeNode(Assign); addChild($$, $1); addChild($$, $3);}
    |  READE '(' IDENT ')' ';'          {$$ = makeNode(ReadE); Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$3); addChild($$, tmp);}
    |  READC '(' IDENT ')' ';'          {$$ = makeNode(ReadC); Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$3); addChild($$, tmp);}
    |  PRINT '(' Exp ')' ';'            {$$ = makeNode(Print); addChild($$, $3);}
    |  IF '(' Exp ')' Instr             %prec "then" {$$ = makeNode(If); addChild($$, $3); addChild($$, $5);} 
    |  IF '(' Exp ')' Instr ELSE Instr  {Node *tmp_if = makeNode(If); Node *tmp_else = makeNode(Else); addChild(tmp_if, $3); addChild(tmp_if, $5); addChild(tmp_else, $7); 
                                         addSibling(tmp_if, tmp_else); $$ = tmp_if;}
    |  WHILE '(' Exp ')' Instr          {$$ = makeNode(While); addChild($$, $3); addSibling($3, $5);}
    |  IDENT '(' Arguments  ')' ';'     {$$ = makeNode(Identifier); strcpy($$->u.identifier,$1); addChild($$, $3);}
    |  RETURN Exp ';'                   {$$ =makeNode(Return); addChild($$, $2);}
    |  RETURN ';'                       {$$ =makeNode(Return);}
    |  '{' SuiteInstr '}'               {$$ = $2;}
    |  ';'                              {$$ = $$;}
    |  error                            {$$ = makeNode(Error); yyclearin;} 
    ;

Exp :  Exp OR TB                        {$$ = makeNode(Or); addChild($$, $1); addChild($$, $3);}
    |  TB                               {$$ = $1;}
    |  error                            {$$ = makeNode(Error); yyclearin;} 
    ;

TB  :  TB AND FB                        {$$ = makeNode(And); addChild($$, $1); addChild($$, $3);}
    |  FB                               {$$ = $1;}
    ;
FB  :  FB EQ M                          {if(!strcmp($<equal>2, "==")){$$ = makeNode(Equal);};
                                         if(!strcmp($<equal>2, "!=")){$$ = makeNode(Different);}; 
                                         addChild($$, $1); addChild($$, $3);}
    |  M                                {$$ = $1;}
    ;
M   :  M ORDER E                        {if(!strcmp($<order>2, "<=")){$$ = makeNode(InfOrEq);};
                                         if(!strcmp($<order>2, ">=")){$$ = makeNode(SupOrEq);};
                                         if(!strcmp($<order>2, "<")){$$ = makeNode(Inf);};
                                         if(!strcmp($<order>2, ">")){$$ = makeNode(Sup);};
                                         addChild($$, $1); addChild($$, $3);}
    |  E                                {$$ = $1;}
    ;
E   :  E ADDSUB T                       {if($2 == '+'){$$ = makeNode(Add);}; if($2 == '-'){$$ = makeNode(Sub);}; addChild($$, $1); addChild($$, $3);}
    |  T                                {$$ = $1;}
    ;    
T   :  T '*' F                          {$$ = makeNode(Mult); addChild($$, $1); addChild($$, $3);}
    |  T '/' F                          {$$ = makeNode(Div); addChild($$, $1); addChild($$, $3);}
    |  T '%' F                          {$$ = makeNode(Mod); addChild($$, $1); addChild($$, $3);}
    |  F                                {$$ = $1;}
    ;
F   :  ADDSUB F                         {if($<signe>1 == '+'){$$ = makeNode(Positif);};
                                         if($<signe>1 == '-'){$$ = makeNode(Negatif);};
                                         addChild($$,$2);}
    |  '!' F                            {$$ = makeNode(Opposite); addChild($$, $2);}
    |  '&' IDENT                        {$$ = makeNode(Adress); Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$2); addChild($$, tmp);}
    |  '(' Exp ')'                      {$$ = $2;}
    |  NUM                              {$$ = makeNode(IntLiteral); $$->u.integer = $1;}
    |  CHARACTER                        {$$ = makeNode(CharLiteral); $$->u.character = $1;}
    |  LValue                           {$$ = $1;}
    |  IDENT '(' Arguments  ')'         {$$ = makeNode(Identifier); strcpy($$->u.identifier,$1); addChild($$, $3);}
    |  '*' IDENT '(' Arguments  ')'     {$$ = makeNode(Pointer); Node *tmp = makeNode(Identifier); strcpy($$->u.identifier,$2); addChild($$, tmp); addChild($$, $4);}
    | IDENT                             {$$ = makeNode(ValueOf); addChild($$, makeNode(Identifier)); strcpy(FIRSTCHILD($$)->u.identifier, $1 );}

    ;
LValue:
       IDENT                            {$$ = makeNode(Identifier); strcpy($$->u.identifier,$1);}
    |  '*' IDENT                        {$$ = makeNode(Pointer); Node *tmp = makeNode(Identifier); strcpy(tmp->u.identifier,$2); addChild($$, tmp);}
    ;
Arguments:
       ListExp                          {$$ = makeNode(ArgList); addChild($$, $1);}
    |                                   {$$ = makeNode(Void);};
ListExp:
       ListExp ',' Exp                  {$$ = $1; addSibling($1, $3);}
    |  Exp                              {$$ = $1;}
    ;
%%
int main(int argc, char** argv) {
    result = yyparse();
    if(parse  > 0){
        printf("\033[0;31mIl y a %d erreur dans votre code\033[0m\n", parse);
    }else{
        int opt, cpt=1;
        char *file_name = (char *)malloc(100 * sizeof(char));
        strcpy(file_name, "");
        while((opt = getopt(argc, argv, "o")) != -1){
            switch(opt){
                case('o'):
                    strcpy(file_name, argv[cpt+1]); cpt += 1; break;
            }
        }
        if(strcmp(file_name, "")==0){
            strcpy(file_name, "trad.asm");
        }

        printTree(abstractTree);
        
        Element redefError = NULL;
        Element declError = NULL;
        TypeErreur *typeError = (TypeErreur*) malloc(sizeof(TypeErreur) *7) ;
        for(int i= 0;i<7;i++){
            typeError[i] = NULL;
        }


        
        Hachage tab =symbolTable(abstractTree, &redefError, &declError);
        
        elementsType(abstractTree, tab, typeError );
        
        printSymboleTable(tab);
        printRedefErrTable (redefError);
        printfDeclErrTable (declError);
        printTypeErrTable(typeError); 
        
        if(redefError != NULL || declError != NULL)
            return 1;
        for(int i= 0;i<5;i++){
            if(typeError[i] != NULL)
                return 1;
        }

        writeNasmFile(tab, abstractTree, file_name);
        


    }
    
    return result || parse != 0 ;
}

void yyerror(char *s){

    fprintf(stderr, "%s", yylval.error); 
    for(int i=0; i<charno-1; i++)
        fprintf(stderr, " ");
    fprintf(stderr, "^\n");
    fprintf(stderr, "\033[0;31m%s :\033[0m  near line %d in caracter %d\n\n", s , lineno, charno);
    parse += 1;
}