using OutOfBound;
using SharpFuzz;
using System;
using System.Collections.Generic;
using System.Text;

namespace OutOfBound.Fuzz
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Fuzzer.OutOfProcess.Run(data =>
            {
                var f = new OutOfBound.ClassUnderTest();
                var bytes = Encoding.UTF8.GetBytes(data);
                f.FuzzMe(bytes);
            });
        }
    }
}
