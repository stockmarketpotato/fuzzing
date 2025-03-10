﻿using SharpFuzz;
using System;

namespace OutOfBound.LibFuzz
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Fuzzer.LibFuzzer.Run(data =>
            {
                var f = new OutOfBound.ClassUnderTest();
                f.FuzzMe(data.ToArray());
            });
        }
    }
}
