using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CheatEngine;
using System.Text.RegularExpressions;

namespace Assembler
{
    public partial class fmSample : Form
    {
        private CheatEngineLibrary lib;

        public fmSample()
        {
            InitializeComponent();
            lib = new CheatEngineLibrary();
        }

        private void btnLoad_Click(object sender, EventArgs e)
        {
            lib.loadEngine();
        }

        private void btnUnload_Click(object sender, EventArgs e)
        {
            lib.unloadEngine();
        }

        private void btnProcesses_Click(object sender, EventArgs e)
        {
            string processes;
            lib.iGetProcessList(out processes);
            foreach (string process in Regex.Split(processes, "\r\n"))
                ltBox.Items.Add(process);
        }

        private void btnOpenProcess_Click(object sender, EventArgs e)
        {
            string pid = ltBox.SelectedItem.ToString();
            pid = pid.Substring(0, pid.IndexOf('-', 0));
            if (!pid.Equals(""))
            {
                lib.iOpenProcess(pid);
                MessageBox.Show("Process opened");
            }
            
        }

        private void btnInject_Click(object sender, EventArgs e)
        {
            lib.iAddScript("example",tbScript.Text);
            lib.iActivateRecord(0, true);
        }
    }
}
