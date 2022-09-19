# Todo requirements

## Structure - Static1

In a perfect world we would like to describe our requirements with a very short description.

    Application: Todo   
        Entity: Task   
            Attribute: [Description$,DueDate@,IsDone!]   

We are using special characters as a shorthand for data types.
- $ is string
- % is integer
- \# is float
- ! is boolean
- @ is date

## Structure - Static2 with implied types

Now lets allow some naming rules to imply some types.

    Application: Todo   
        Entity: Task   
            Attribute: [Description,DueDate,IsDone]   

Now the rules are say:
- Attribute.name like *Date  => Attribute.type is date
- Attribute.name like Is* => Attribute.type is boolean
- Catch all others => Attribute.type is string

As rules can overlap e.g. IsFunnyDate will match boolean and date rules, we need to decide on a first or last precedence. My inclination is to take the first match as many language switch statements take the first, although CSS seems to take the last.

## Structure - Static3 with a simple relationship

Now there are lots of ways to distinguish relationships and lots of types of relationships. So let us start with a 1-many classify type relationship.
For now, let us treat the relationship naively as a simple attribute at each end.

    Application: Todo   
        Entity: Task   
            Attribute: [Description,DueDate,IsDone,TaskGroup]
        Entity: TaskGroup
            Attribute: [Name,Tasks]  


At one end of the relationship, we have a perfect match of attribute.name=TaskGroup and Entity.name=TaskGroup. However, at the other end of the relationship, we have Attribute.name=Task and Entity.name=Tasks. Therefore, if we wish to retain a simple natural language approach to the requirement we will need some default pluralisation rules.

