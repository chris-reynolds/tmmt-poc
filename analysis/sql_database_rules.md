# Transformation rules for sql tables

1. One table per class unless not.
2. One column per attribute unless not.
3. One column per association unless not.
4. A few other columns per table as standard.
5. One or two indexes per association.
6. Possible uniqueness constraints based on one or more columns.
7. Sub-classes collapsed into a single table.
8. Extra status column(s) for life-cycle support.
9. Extra columns for performance accumulation. 


So our incoming model has classes, attributes, associations and other bits while our outgoing model has tables, columns, indexes, foreign-keys, constraints and other such database items.

