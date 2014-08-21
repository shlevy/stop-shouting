# Lower-case all non-initial upper-case letters in a text node
quietNode = (text) ->
  # Find all words with more than one character
  reg = /(\S)(\S+)/g
  while match = reg.exec text.data
    capture = match[2]
    lowerCapture = capture.toLocaleLowerCase()
    unless capture is lowerCapture
      # Replace the capture with the lower-cased version
      text.replaceData match.index + match[1].length, capture.length, lowerCapture

  # If we have two adjacent text nodes and a word spans the boundary, we need
  # to lowercase the word in the sibling. Won't work if we have Fo<b>O</b>, oh
  # well.
  next = text.nextSibling
  if next? and next.nodeType is Node.TEXT_NODE
    # Skip empty text nodes
    until next.data
      next = next.nextSibling
      unless next? and next.nodeType is Node.TEXT_NODE
        return

    # Do we end with a word?
    if /\S$/.test text.data
      # Does the sibling start with a word?
      match = /^\S+/.exec next.data
      if match?
        capture = match[0]
        lowerCapture = capture.toLocaleLowerCase()
        unless capture is lowerCapture
          next.replaceData 0, capture.length, lowerCapture

  return

# Quiet all text nodes in a tree
quietTree = (parent) ->
  # Filter out strings in scripts
  exclude = acceptNode: (node) ->
    parent = node.parentElement
    if parent? and parent.tagName.toUpperCase() isnt "SCRIPT"
      NodeFilter.FILTER_ACCEPT
    else
      NodeFilter.FILTER_REJECT

  # Walk the node for text nodes
  walker = document.createTreeWalker parent, NodeFilter.SHOW_TEXT, exclude
  while node = walker.nextNode()
    quietNode node

  return

quietTree document.documentElement

observer = new MutationObserver (records) ->
  for record in records
    if record.type is "characterData"
      quietNode record.target
    else
      quietTree record.target
  return

observer.observe document.documentElement,
  childList: true
  subtree: true
  characterData: true
