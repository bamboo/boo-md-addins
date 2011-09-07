namespace Boo.MonoDevelop.Highlighting

import Mono.TextEditor
import Mono.TextEditor.Highlighting
import System.Collections.Generic

class BooSyntaxMode(SyntaxMode):
	def constructor():
		provider = ResourceXmlProvider(GetType().Assembly, "BooSyntaxMode.xml")
		using reader = provider.Open():
			baseMode = SyntaxMode.Read(reader)
			self.rules = List[of Rule](baseMode.Rules)
			self.keywords = List[of Keywords](baseMode.Keywords)
			self.spans = baseMode.Spans
			self.matches = baseMode.Matches
			self.prevMarker = baseMode.PrevMarker
			self.SemanticRules = List[of SemanticRule](baseMode.SemanticRules)
			self.keywordTable = baseMode.keywordTable
			self.properties = baseMode.Properties
			
