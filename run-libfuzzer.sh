#! /bin/bash
pwsh sharpfuzz/scripts/fuzz-libfuzzer.ps1 -libFuzzer "libfuzzer-dotnet" `
	 -project src/OutOfBound.LibFuzz/OutOfBound.LibFuzz.csproj `
	 -corpus src/OutOfBound.LibFuzz/Testcases
