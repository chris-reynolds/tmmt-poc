grammar TmParser;

// options { tokenVocab=tm_lexer; }

file        : (importsmt+)? application+ EOF;


importsmt      : IMPORT_PREFIX  filename ;

application        : APPLICATION_PREFIX oNAME (single_entity* | entity_array) ;

single_entity  : ENTITY_PREFIX entity ;

entity_array  : ENTITY_PREFIX '[' entity ( entity)* ']';

entity        : oNAME (singleAttribute+ | attribute_array);

singleAttribute: ATTRIBUTE_PREFIX attribute;

attribute_array: ATTRIBUTE_PREFIX  '[' attribute (',' attribute)* ']' ;

attribute: oNAME DATATYPE? propertyList? ;

propertyList : '(' property (',' property)? ')';
property   : propname ('=' string)? ; 
propname   : UNSPACED;

filename    : string;

oNAME               : UNSPACED;
string             : QUOTEDSTRING | UNSPACED;


IMPORT_PREFIX       : ('I'|'i') 'mport:';
APPLICATION_PREFIX  : 'Application:';
ENTITY_PREFIX       : 'Entity:';
ATTRIBUTE_PREFIX    : 'Attribute:';
KEYWORD             :  APPLICATION_PREFIX | ENTITY_PREFIX | ATTRIBUTE_PREFIX;      
DATATYPE            : ('$' | '%' | '#' | '!' | '@' );
UNSPACED          : LETTER (LETTER | NUMBER | '-')*;
SPACED          : LETTER ((LETTER | NUMBER | ' ')* (LETTER | NUMBER))?;
QUOTEDSTRING        : '"' ('\\"'|~["])*? '"' ;
STRING              : QUOTEDSTRING | UNSPACED;
WSNL                  : [ \t\r\n] -> skip ;
fragment LETTER    : [a-zA-Z] ;
fragment NUMBER    : [0-9] ;