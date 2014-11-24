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
using System.Diagnostics;

namespace Scanner
{
    public partial class Main : Form
    {
        private CheatEngineLibrary lib;
        private TScanOption scanopt;
        private TVariableType varopt;
        private bool unicode;
        private bool casesensitive;
        private string startscan;
        private string  endscan;

        private const int wm_scandone = 0x8000 + 2;
        protected override void WndProc(ref Message m)
        {
            int size,i;
            if (m.Msg == wm_scandone)
            {
                lvScanner.VirtualListSize = 0;
                lvScanner.Items.Clear();
                btnNextScan.Enabled = true;
                size = lib.iGetBinarySize();

                if (varopt == TVariableType.vtString)
                    if (unicode)
                        lib.iInitFoundList(varopt, size/16, false, false, false, unicode);
                    else
                        lib.iInitFoundList(varopt, size/8, false, false, false, unicode);
                else
                    lib.iInitFoundList(varopt, size, false, false, false, unicode);
                if (scanopt != TScanOption.soUnknownValue)
                {
                    i = Math.Min((int)lib.iCountAddressesFound(), 10000000);
                    lvScanner.VirtualListSize = i;
                }
                MessageBox.Show(lib.iCountAddressesFound().ToString());
                timer1.Enabled = true;
            }
            else
            {
                base.WndProc(ref m);
            }
        }
        public Main()
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
                lib.iInitMemoryScanner(Process.GetCurrentProcess().MainWindowHandle.ToInt32());
                MessageBox.Show("Process opened");
                scanopt = TScanOption.soExactValue;
                varopt = TVariableType.vtDword;
                startscan = "$0000000000000000";
                endscan = "$7fffffffffffffff";
                unicode = false;
                casesensitive = false;
                btnNewScan.Enabled = true;
                btnFirstScan.Enabled = true;
            }
        }

        private void btnNewScan_Click(object sender, EventArgs e)
        {
            lib.iNewScan();
            btnNextScan.Enabled = false;
            btnFirstScan.Enabled = true;
            lvScanner.VirtualListSize = 0;
        }

        private void btnFirstScan_Click(object sender, EventArgs e)
        {
            TFastScanMethod fastscanmethod ;
            Tscanregionpreference writable = Tscanregionpreference.scanInclude, 
                executable = Tscanregionpreference.scanDontCare, copyOnWrite = Tscanregionpreference.scanExclude ;
            timer1.Enabled = false;
            btnFirstScan.Enabled = false;

            switch(cbWritable.CheckState)
            {
                case CheckState.Unchecked : writable = Tscanregionpreference.scanExclude; break;
                case CheckState.Checked : writable = Tscanregionpreference.scanInclude; break;
                case CheckState.Indeterminate : writable = Tscanregionpreference.scanDontCare; break;
            }

            switch(cbExecutable.CheckState)
            {
                case CheckState.Unchecked : executable = Tscanregionpreference.scanExclude; break;
                case CheckState.Checked : executable = Tscanregionpreference.scanInclude; break;
                case CheckState.Indeterminate : executable = Tscanregionpreference.scanDontCare; break;
            }

            switch(cbCopyOnWrite.CheckState)
            {
                case CheckState.Unchecked : copyOnWrite = Tscanregionpreference.scanExclude; break;
                case CheckState.Checked : copyOnWrite = Tscanregionpreference.scanInclude; break;
                case CheckState.Indeterminate : copyOnWrite = Tscanregionpreference.scanDontCare; break;
            }

            lib.iConfigScanner(writable,executable,copyOnWrite);

            if (cbFastScan.Checked)
            {
                if (rbAlignment.Checked)
                    fastscanmethod = TFastScanMethod.fsmAligned;
                else
                    fastscanmethod = TFastScanMethod.fsmLastDigits;
            }
            else fastscanmethod = TFastScanMethod.fsmNotAligned;

            lib.iFirstScan(scanopt, varopt, TRoundingType.rtRounded, tbValue1.Text,
            tbValue2.Text, startscan, endscan, false, false, unicode, casesensitive,
            fastscanmethod, tbAlignment.Text);
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            lib.iResetValues();
            lvScanner.Refresh();
        }

        private void tbStartScan_TextChanged(object sender, EventArgs e)
        {
            startscan = '$' + tbStartScan.Text;
        }

        private void tbEndScan_TextChanged(object sender, EventArgs e)
        {
            endscan = '$' + tbEndScan.Text;
        }

        private void cbScanType_SelectedIndexChanged(object sender, EventArgs e)
        {
              switch (cbScanType.SelectedIndex)
              {
                  case 0: scanopt = TScanOption.soUnknownValue; break;
                  case 1: scanopt = TScanOption.soExactValue; break;
                  case 2:scanopt = TScanOption.soValueBetween;break;
                  case 3:scanopt = TScanOption.soBiggerThan;break;
                  case 4:scanopt = TScanOption.soSmallerThan;break;
                  case 5:scanopt = TScanOption.soIncreasedValue;break;
                  case 6:scanopt = TScanOption.soIncreasedValueBy;break;
                  case 7: scanopt = TScanOption.soDecreasedValue;break;
                  case 8:scanopt = TScanOption.soIncreasedValueBy;break;
                  case 9:scanopt = TScanOption.soChanged;break;
                  case 10: scanopt = TScanOption.soUnchanged; break;
              }
        }

        private void cbValueType_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (cbValueType.SelectedIndex)
            {
                case 0: varopt = TVariableType.vtBinary; break;
                case 1: varopt = TVariableType.vtByte; break;
                case 2: varopt = TVariableType.vtWord; break;
                case 3: varopt = TVariableType.vtDword; break;
                case 4: varopt = TVariableType.vtQword; break;
                case 5: varopt = TVariableType.vtSingle; break;
                case 6: varopt = TVariableType.vtDouble; break;
                case 7: varopt = TVariableType.vtString; break;
            }

            switch (varopt)
            {
                case TVariableType.vtBinary :
                case TVariableType.vtByte :
                case TVariableType.vtString : 
                case TVariableType.vtUnicodeString :
                case TVariableType.vtByteArrays: tbAlignment.Text = "1"; break;
                case TVariableType.vtWord: tbAlignment.Text = "2"; break;
                default: tbAlignment.Text = "4"; break;
            }
        }

        private void cbFastScan_CheckedChanged(object sender, EventArgs e)
        {
            tbAlignment.Enabled = cbFastScan.Checked && cbFastScan.Enabled;
            rbAlignment.Enabled = tbAlignment.Enabled;
            rbLastDigits.Enabled = tbAlignment.Enabled;
        }

        private void lvScanner_RetrieveVirtualItem(object sender, RetrieveVirtualItemEventArgs e)
        {
            string address, value;
            try 
            {
                ListViewItem lvi = new ListViewItem(); 	// create a listviewitem object
                lib.iGetAddress(e.ItemIndex, out address, out value);
                lvi.Text = address; 		// assign the text to the item
                ListViewItem.ListViewSubItem lvsi = new ListViewItem.ListViewSubItem(); // subitem
                lvsi.Text = value; 	// the subitem text
                lvi.SubItems.Add(lvsi); 			// assign subitem to item
                e.Item = lvi; 		// assign item to event argument's item-property
            }
            catch (Exception ex)
            {
            }
            
        }

        private void fmScanner_Load(object sender, EventArgs e)
        {
            cbScanType.SelectedIndex = cbScanType.Items.IndexOf("Exact Value");
            cbValueType.SelectedIndex = cbValueType.Items.IndexOf("4 Bytes");
 
        }

        private void btnNextScan_Click(object sender, EventArgs e)
        {
            timer1.Enabled = false;
            btnNextScan.Enabled = false;
            lib.iNextScan(scanopt, TRoundingType.rtRounded, tbValue1.Text, tbValue2.Text,
    false, false, unicode, casesensitive, false, false, "");
        }

        private void cbUnicode_CheckedChanged(object sender, EventArgs e)
        {
            unicode = cbUnicode.Checked;
        }

        private void cbCase_CheckedChanged(object sender, EventArgs e)
        {
            casesensitive = cbCase.Checked;
        }

    }
}
