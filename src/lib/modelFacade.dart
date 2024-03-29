// file: Model Facade
// author: Chris Reynolds
// date: 21st November 2019

///  Purpose of this file
/// We need to load a json model (maybe from stdin)
/// and load a set of inplace model enrichments for
/// processing by a macro processor.
/// It will also need to understand a tree of scopes
/// so that that it can walk up looking for a value.

//TASK: Implment simple property bag,S,W,2019-11-22
//TASK: Load Ruleset,M,W,2019-11-22
//TASK: Implment rule set matching,M,W,2019-11-22
//TASK: Scope cascade,M,W,2019-11-22
//TASK: Use data type defaults,M,W,2019-11-22
//TASK: Implment String transformers,M,W,2019-11-22
//TASK: Multiple ruleset files,M,W,2019-11-22

/* The rule is applied to an object if one of its selectors
     matches that object */
class Rule {
  final String name;
  final String _value;
  Rule(this.name, String value) : _value = value;
  String value(dynamic object) {
    return _value; // todo decide on rule syntax and evaluation
  }
} // of Rule

class RuleBlock {
  List<Selector> selectors = [];
  List<Rule> rules = [];
}

class Scope {
  Scope parent;
  Map<String, dynamic> values;
  Scope({required this.parent, required this.values});
} // of scope

/* The selector class is used to decide which rules to apply. */
class Selector {} // of Selector
