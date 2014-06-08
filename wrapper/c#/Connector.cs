using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace CheatEngine {

    class CheatEngineLibrary
    {

        // Static invocations.
        [DllImport("kernel32.dll", EntryPoint = "LoadLibraryW", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Winapi)]
        extern static IntPtr LoadLibraryW(String strLib);

        [DllImport("kernel32.dll")]
        extern static IntPtr LoadLibrary(String strLib);

        [DllImport("kernel32.dll")]
        extern static int FreeLibrary(IntPtr iModule);

        [DllImport("kernel32.dll", EntryPoint = "GetProcAddress", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Winapi)]
        extern static IntPtr GetProcAddress(IntPtr iModule, String strProcName);

        public delegate void IGetProcessList([MarshalAs(UnmanagedType.BStr)] out string processes);
        public delegate void IOpenProcess([MarshalAs(UnmanagedType.BStr)] string pid);
        public delegate void IResetScripts();
        public delegate void IAddScript([MarshalAs(UnmanagedType.BStr)] string name, [MarshalAs(UnmanagedType.BStr)] string script);
        public delegate void IRemoveScript(int id);
        public delegate void IActivateScript(int id, bool activate);

        private IntPtr libInst;

        public IGetProcessList iGetProcessList;
        public IOpenProcess iOpenProcess;
        public IResetScripts iResetScripts;
        public IAddScript iAddScript;
        public IRemoveScript iRemoveScript;
        public IActivateScript iActivateScript;
        private void loadFunctions()
        {
            IntPtr pGetProcessList = GetProcAddress(libInst, "IGetProcessList");
            IntPtr pOpenProcess = GetProcAddress(libInst, "IOpenProcess");
            IntPtr pResetScripts = GetProcAddress(libInst, "IResetScripts");
            IntPtr pAddScript = GetProcAddress(libInst, "IAddScript");
            IntPtr pRemoveScript = GetProcAddress(libInst, "IRemoveScript");
            IntPtr pActivateScript = GetProcAddress(libInst, "IActivateScript");

            iGetProcessList = (IGetProcessList)Marshal.GetDelegateForFunctionPointer(pGetProcessList, typeof(IGetProcessList));
            iOpenProcess = (IOpenProcess)Marshal.GetDelegateForFunctionPointer(pOpenProcess, typeof(IOpenProcess));
            iResetScripts = (IResetScripts)Marshal.GetDelegateForFunctionPointer(pResetScripts, typeof(IResetScripts));
            iAddScript = (IAddScript)Marshal.GetDelegateForFunctionPointer(pAddScript, typeof(IAddScript));
            iRemoveScript = (IRemoveScript)Marshal.GetDelegateForFunctionPointer(pRemoveScript, typeof(IRemoveScript));
            iActivateScript = (IActivateScript)Marshal.GetDelegateForFunctionPointer(pActivateScript, typeof(IActivateScript));
        }
        public void loadEngine()
        {
            //#if _WIN64
            libInst = LoadLibraryW("ce-lib64.dll");
            //#else
            //libInst = LoadLibrary("ce-lib32.dll");
            //#endif
            if (libInst != IntPtr.Zero)
            {
                MessageBox.Show("loaded");
            }
            loadFunctions();
        }

        public void unloadEngine()
        {
            FreeLibrary(libInst);
        }

    }

}

