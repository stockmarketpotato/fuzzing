using System;

namespace OutOfBound
{
    public class ClassUnderTest
    {
        public bool FuzzMe(byte[] data)
        {
            return data.Length >= 3 &&
                data[0] == 'F' &&
                data[1] == 'U' &&
                data[2] == 'Z' &&
                data[3] == 'Z';  // :‑<
        }
    }
}
