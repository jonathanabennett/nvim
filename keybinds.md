# Keybindings for my Config

This is intended to organize my keybindings to avoid conflicts and hopefully make them sensible. They will be organized by prefix first, though I may reorganize them by category later.

## <LEADER>
These are top-level binds, they require no prefix.

- D :: LSP Type Definition
- f :: Format buffer (fixes indentation, etc.)
- n :: Reveals neotree buffer to the left
- q :: Opens diagnostic quick-fix list
- / :: Fuzzy search in current buffer
- <space> :: Find in existing buffers

## g 
These tend to be LSP related as they "Go" to a given destination

- d :: Goto Definition
- D :: Goto Declaration 
- I :: Goto Implementation
- r :: Goto References 
- e :: Prev end of word
- f :: File under cursor
- g :: First line 
- i :: Last insert
- n :: Search forward and select 
- N :: Search backward and select
- t :: Next tab page
- T :: Prev tab page
- u :: lowercase 
- U :: Uppercase
- v :: Last visual selection
- w :: format (Sub-menu)
- x :: Opens file under cursor using the system handler (Use this for hyperlinks). TODO: Currently Broken
   Example: www.google.com
- % :: Cycle backward through results
- [ :: Opening "around" 
- ] :: closing "around"
  - follow with the "around" you're targeting: ex: [{("' or ]})"'
- ~ :: Toggle Case (follow with a movement)
- cc :: toggle comment
- ' :: marks menu
- ` :: marks menu

## z
Folds. These don't work yet, so I'm skipping them

