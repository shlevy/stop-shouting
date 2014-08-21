STOP SHOUTING
==============

Chromium extension that makes all letters that don't start a word lower-case.

Known limitations
------------------

* Uses `/\S+/` to match words, which may cause odd things to happen with non-English text
* Won't catch words with interspersed markup, e.g. the last O in `Fo<b>O</b>` will not be lowered
