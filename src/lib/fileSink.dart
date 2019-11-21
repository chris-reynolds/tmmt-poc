// file: File-Sink
// author: Chris Reynolds
// date: 21st November 2019

/**  Purpose of this file
 * This takes a stream of text from stdin and
 * executes any embedded commands. 
 * In general the text stream is written to the
 * nominated file.
 * Requirement Statments:
 * 1. Write contents to new file.
 * 2. Only write to existing file if contents have changed.
 * 3. Protect custom code blocks.
 * 4. Insert codegen blocks.
 * 5. Allow custom code blocks to be initialised.
 * 6. Backup original file if required. 
 * **/

