namespace Scanner
{
    partial class Main
    {
        /// <summary>
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur Windows Form

        /// <summary>
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.panel1 = new System.Windows.Forms.Panel();
            this.ltBox = new System.Windows.Forms.ListBox();
            this.btnOpenProcess = new System.Windows.Forms.Button();
            this.btnProcesses = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnUnload = new System.Windows.Forms.Button();
            this.btnLoad = new System.Windows.Forms.Button();
            this.lvScanner = new System.Windows.Forms.ListView();
            this.colAddress = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.colValue = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.btnNewScan = new System.Windows.Forms.Button();
            this.btnFirstScan = new System.Windows.Forms.Button();
            this.btnNextScan = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.tbValue1 = new System.Windows.Forms.TextBox();
            this.tbValue2 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.cbScanType = new System.Windows.Forms.ComboBox();
            this.cbValueType = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.cbCopyOnWrite = new System.Windows.Forms.CheckBox();
            this.cbExecutable = new System.Windows.Forms.CheckBox();
            this.cbWritable = new System.Windows.Forms.CheckBox();
            this.tbEndScan = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.tbStartScan = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.rbLastDigits = new System.Windows.Forms.RadioButton();
            this.rbAlignment = new System.Windows.Forms.RadioButton();
            this.tbAlignment = new System.Windows.Forms.TextBox();
            this.cbFastScan = new System.Windows.Forms.CheckBox();
            this.cbCase = new System.Windows.Forms.CheckBox();
            this.cbUnicode = new System.Windows.Forms.CheckBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.panel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.ltBox);
            this.panel1.Controls.Add(this.btnOpenProcess);
            this.panel1.Controls.Add(this.btnProcesses);
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel1.Location = new System.Drawing.Point(510, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(246, 576);
            this.panel1.TabIndex = 4;
            // 
            // ltBox
            // 
            this.ltBox.AccessibleName = "";
            this.ltBox.Location = new System.Drawing.Point(16, 183);
            this.ltBox.Name = "ltBox";
            this.ltBox.Size = new System.Drawing.Size(218, 381);
            this.ltBox.TabIndex = 5;
            // 
            // btnOpenProcess
            // 
            this.btnOpenProcess.Location = new System.Drawing.Point(66, 147);
            this.btnOpenProcess.Name = "btnOpenProcess";
            this.btnOpenProcess.Size = new System.Drawing.Size(131, 23);
            this.btnOpenProcess.TabIndex = 4;
            this.btnOpenProcess.Text = "Open Selected Process";
            this.btnOpenProcess.UseVisualStyleBackColor = true;
            this.btnOpenProcess.Click += new System.EventHandler(this.btnOpenProcess_Click);
            // 
            // btnProcesses
            // 
            this.btnProcesses.Location = new System.Drawing.Point(66, 118);
            this.btnProcesses.Name = "btnProcesses";
            this.btnProcesses.Size = new System.Drawing.Size(122, 23);
            this.btnProcesses.TabIndex = 3;
            this.btnProcesses.Text = "Process List";
            this.btnProcesses.UseVisualStyleBackColor = true;
            this.btnProcesses.Click += new System.EventHandler(this.btnProcesses_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnUnload);
            this.groupBox1.Controls.Add(this.btnLoad);
            this.groupBox1.Location = new System.Drawing.Point(16, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(218, 100);
            this.groupBox1.TabIndex = 2;
            this.groupBox1.TabStop = false;
            // 
            // btnUnload
            // 
            this.btnUnload.Location = new System.Drawing.Point(50, 48);
            this.btnUnload.Name = "btnUnload";
            this.btnUnload.Size = new System.Drawing.Size(122, 23);
            this.btnUnload.TabIndex = 2;
            this.btnUnload.Text = "Unload Library";
            this.btnUnload.UseVisualStyleBackColor = true;
            this.btnUnload.Click += new System.EventHandler(this.btnUnload_Click);
            // 
            // btnLoad
            // 
            this.btnLoad.Location = new System.Drawing.Point(50, 19);
            this.btnLoad.Name = "btnLoad";
            this.btnLoad.Size = new System.Drawing.Size(122, 23);
            this.btnLoad.TabIndex = 1;
            this.btnLoad.Text = "Load Library";
            this.btnLoad.UseVisualStyleBackColor = true;
            this.btnLoad.Click += new System.EventHandler(this.btnLoad_Click);
            // 
            // lvScanner
            // 
            this.lvScanner.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.colAddress,
            this.colValue});
            this.lvScanner.Location = new System.Drawing.Point(12, 346);
            this.lvScanner.Name = "lvScanner";
            this.lvScanner.Size = new System.Drawing.Size(492, 218);
            this.lvScanner.TabIndex = 5;
            this.lvScanner.UseCompatibleStateImageBehavior = false;
            this.lvScanner.View = System.Windows.Forms.View.Details;
            this.lvScanner.VirtualMode = true;
            this.lvScanner.RetrieveVirtualItem += new System.Windows.Forms.RetrieveVirtualItemEventHandler(this.lvScanner_RetrieveVirtualItem);
            // 
            // colAddress
            // 
            this.colAddress.Text = "Address";
            this.colAddress.Width = 183;
            // 
            // colValue
            // 
            this.colValue.Text = "Value";
            this.colValue.Width = 183;
            // 
            // btnNewScan
            // 
            this.btnNewScan.Enabled = false;
            this.btnNewScan.Location = new System.Drawing.Point(12, 12);
            this.btnNewScan.Name = "btnNewScan";
            this.btnNewScan.Size = new System.Drawing.Size(75, 23);
            this.btnNewScan.TabIndex = 6;
            this.btnNewScan.Text = "New Scan";
            this.btnNewScan.UseVisualStyleBackColor = true;
            this.btnNewScan.Click += new System.EventHandler(this.btnNewScan_Click);
            // 
            // btnFirstScan
            // 
            this.btnFirstScan.Enabled = false;
            this.btnFirstScan.Location = new System.Drawing.Point(106, 12);
            this.btnFirstScan.Name = "btnFirstScan";
            this.btnFirstScan.Size = new System.Drawing.Size(75, 23);
            this.btnFirstScan.TabIndex = 7;
            this.btnFirstScan.Text = "First Scan";
            this.btnFirstScan.UseVisualStyleBackColor = true;
            this.btnFirstScan.Click += new System.EventHandler(this.btnFirstScan_Click);
            // 
            // btnNextScan
            // 
            this.btnNextScan.Enabled = false;
            this.btnNextScan.Location = new System.Drawing.Point(198, 12);
            this.btnNextScan.Name = "btnNextScan";
            this.btnNextScan.Size = new System.Drawing.Size(75, 23);
            this.btnNextScan.TabIndex = 8;
            this.btnNextScan.Text = "Next Scan";
            this.btnNextScan.UseVisualStyleBackColor = true;
            this.btnNextScan.Click += new System.EventHandler(this.btnNextScan_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 60);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 9;
            this.label1.Text = "Value 1 :";
            // 
            // tbValue1
            // 
            this.tbValue1.Location = new System.Drawing.Point(64, 57);
            this.tbValue1.Name = "tbValue1";
            this.tbValue1.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.tbValue1.Size = new System.Drawing.Size(122, 20);
            this.tbValue1.TabIndex = 10;
            // 
            // tbValue2
            // 
            this.tbValue2.Location = new System.Drawing.Point(273, 57);
            this.tbValue2.Name = "tbValue2";
            this.tbValue2.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.tbValue2.Size = new System.Drawing.Size(122, 20);
            this.tbValue2.TabIndex = 12;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(218, 60);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 13);
            this.label2.TabIndex = 11;
            this.label2.Text = "Value 2 :";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 99);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(65, 13);
            this.label3.TabIndex = 13;
            this.label3.Text = "Scan Type :";
            // 
            // cbScanType
            // 
            this.cbScanType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbScanType.FormattingEnabled = true;
            this.cbScanType.ItemHeight = 13;
            this.cbScanType.Items.AddRange(new object[] {
            "UnknownValue",
            "Exact Value",
            "Value Between",
            "Bigger Than",
            "Smaller Than",
            "Increased Value",
            "Increased ValueBy",
            "Decreased Value",
            "Decreased Value By",
            "Changed Value",
            "Unchanged Value"});
            this.cbScanType.Location = new System.Drawing.Point(80, 96);
            this.cbScanType.Name = "cbScanType";
            this.cbScanType.Size = new System.Drawing.Size(150, 21);
            this.cbScanType.TabIndex = 14;
            this.cbScanType.SelectedIndexChanged += new System.EventHandler(this.cbScanType_SelectedIndexChanged);
            // 
            // cbValueType
            // 
            this.cbValueType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbValueType.FormattingEnabled = true;
            this.cbValueType.ItemHeight = 13;
            this.cbValueType.Items.AddRange(new object[] {
            "Binary",
            "Byte",
            "2 Bytes",
            "4 Bytes",
            "8 Bytes",
            "Float",
            "Double",
            "String"});
            this.cbValueType.Location = new System.Drawing.Point(80, 132);
            this.cbValueType.Name = "cbValueType";
            this.cbValueType.Size = new System.Drawing.Size(150, 21);
            this.cbValueType.TabIndex = 16;
            this.cbValueType.SelectedIndexChanged += new System.EventHandler(this.cbValueType_SelectedIndexChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(9, 135);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(67, 13);
            this.label4.TabIndex = 15;
            this.label4.Text = "Value Type :";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.cbCopyOnWrite);
            this.groupBox2.Controls.Add(this.cbExecutable);
            this.groupBox2.Controls.Add(this.cbWritable);
            this.groupBox2.Controls.Add(this.tbEndScan);
            this.groupBox2.Controls.Add(this.label5);
            this.groupBox2.Controls.Add(this.tbStartScan);
            this.groupBox2.Controls.Add(this.label6);
            this.groupBox2.Location = new System.Drawing.Point(12, 159);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(480, 89);
            this.groupBox2.TabIndex = 18;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Memory Scan option";
            // 
            // cbCopyOnWrite
            // 
            this.cbCopyOnWrite.AutoSize = true;
            this.cbCopyOnWrite.Location = new System.Drawing.Point(224, 50);
            this.cbCopyOnWrite.Name = "cbCopyOnWrite";
            this.cbCopyOnWrite.Size = new System.Drawing.Size(89, 17);
            this.cbCopyOnWrite.TabIndex = 19;
            this.cbCopyOnWrite.Text = "CopyOnWrite";
            this.cbCopyOnWrite.ThreeState = true;
            this.cbCopyOnWrite.UseVisualStyleBackColor = true;
            // 
            // cbExecutable
            // 
            this.cbExecutable.AutoSize = true;
            this.cbExecutable.Checked = true;
            this.cbExecutable.CheckState = System.Windows.Forms.CheckState.Indeterminate;
            this.cbExecutable.Location = new System.Drawing.Point(138, 50);
            this.cbExecutable.Name = "cbExecutable";
            this.cbExecutable.Size = new System.Drawing.Size(79, 17);
            this.cbExecutable.TabIndex = 18;
            this.cbExecutable.Text = "Executable";
            this.cbExecutable.ThreeState = true;
            this.cbExecutable.UseVisualStyleBackColor = true;
            // 
            // cbWritable
            // 
            this.cbWritable.AutoSize = true;
            this.cbWritable.Checked = true;
            this.cbWritable.CheckState = System.Windows.Forms.CheckState.Checked;
            this.cbWritable.Location = new System.Drawing.Point(52, 50);
            this.cbWritable.Name = "cbWritable";
            this.cbWritable.Size = new System.Drawing.Size(65, 17);
            this.cbWritable.TabIndex = 17;
            this.cbWritable.Text = "Writable";
            this.cbWritable.ThreeState = true;
            this.cbWritable.UseVisualStyleBackColor = true;
            // 
            // tbEndScan
            // 
            this.tbEndScan.Location = new System.Drawing.Point(283, 24);
            this.tbEndScan.Name = "tbEndScan";
            this.tbEndScan.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.tbEndScan.Size = new System.Drawing.Size(179, 20);
            this.tbEndScan.TabIndex = 16;
            this.tbEndScan.Text = "7FFFFFFFFFFFFFFF";
            this.tbEndScan.TextChanged += new System.EventHandler(this.tbEndScan_TextChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(242, 27);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(35, 13);
            this.label5.TabIndex = 15;
            this.label5.Text = "Stop :";
            // 
            // tbStartScan
            // 
            this.tbStartScan.Location = new System.Drawing.Point(54, 24);
            this.tbStartScan.Name = "tbStartScan";
            this.tbStartScan.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.tbStartScan.Size = new System.Drawing.Size(164, 20);
            this.tbStartScan.TabIndex = 14;
            this.tbStartScan.Text = "0000000000000000";
            this.tbStartScan.TextChanged += new System.EventHandler(this.tbStartScan_TextChanged);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(13, 27);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(35, 13);
            this.label6.TabIndex = 13;
            this.label6.Text = "Start :";
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.rbLastDigits);
            this.groupBox3.Controls.Add(this.rbAlignment);
            this.groupBox3.Controls.Add(this.tbAlignment);
            this.groupBox3.Controls.Add(this.cbFastScan);
            this.groupBox3.Controls.Add(this.cbCase);
            this.groupBox3.Controls.Add(this.cbUnicode);
            this.groupBox3.Location = new System.Drawing.Point(12, 254);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(480, 86);
            this.groupBox3.TabIndex = 19;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Optional options";
            // 
            // rbLastDigits
            // 
            this.rbLastDigits.AutoSize = true;
            this.rbLastDigits.Enabled = false;
            this.rbLastDigits.Location = new System.Drawing.Point(312, 41);
            this.rbLastDigits.Name = "rbLastDigits";
            this.rbLastDigits.Size = new System.Drawing.Size(64, 17);
            this.rbLastDigits.TabIndex = 22;
            this.rbLastDigits.Text = "Last bits";
            this.rbLastDigits.UseVisualStyleBackColor = true;
            // 
            // rbAlignment
            // 
            this.rbAlignment.AutoSize = true;
            this.rbAlignment.Checked = true;
            this.rbAlignment.Location = new System.Drawing.Point(312, 18);
            this.rbAlignment.Name = "rbAlignment";
            this.rbAlignment.Size = new System.Drawing.Size(71, 17);
            this.rbAlignment.TabIndex = 21;
            this.rbAlignment.TabStop = true;
            this.rbAlignment.Text = "Alignment";
            this.rbAlignment.UseVisualStyleBackColor = true;
            // 
            // tbAlignment
            // 
            this.tbAlignment.Location = new System.Drawing.Point(245, 17);
            this.tbAlignment.Name = "tbAlignment";
            this.tbAlignment.ReadOnly = true;
            this.tbAlignment.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.tbAlignment.Size = new System.Drawing.Size(61, 20);
            this.tbAlignment.TabIndex = 20;
            // 
            // cbFastScan
            // 
            this.cbFastScan.AutoSize = true;
            this.cbFastScan.Checked = true;
            this.cbFastScan.CheckState = System.Windows.Forms.CheckState.Checked;
            this.cbFastScan.Location = new System.Drawing.Point(166, 19);
            this.cbFastScan.Name = "cbFastScan";
            this.cbFastScan.Size = new System.Drawing.Size(74, 17);
            this.cbFastScan.TabIndex = 2;
            this.cbFastScan.Text = "Fast Scan";
            this.cbFastScan.UseVisualStyleBackColor = true;
            this.cbFastScan.CheckedChanged += new System.EventHandler(this.cbFastScan_CheckedChanged);
            // 
            // cbCase
            // 
            this.cbCase.AutoSize = true;
            this.cbCase.Location = new System.Drawing.Point(52, 42);
            this.cbCase.Name = "cbCase";
            this.cbCase.Size = new System.Drawing.Size(96, 17);
            this.cbCase.TabIndex = 1;
            this.cbCase.Text = "Case Sensitive";
            this.cbCase.UseVisualStyleBackColor = true;
            // 
            // cbUnicode
            // 
            this.cbUnicode.AutoSize = true;
            this.cbUnicode.Location = new System.Drawing.Point(52, 19);
            this.cbUnicode.Name = "cbUnicode";
            this.cbUnicode.Size = new System.Drawing.Size(66, 17);
            this.cbUnicode.TabIndex = 0;
            this.cbUnicode.Text = "Unicode";
            this.cbUnicode.UseVisualStyleBackColor = true;
            this.cbUnicode.CheckedChanged += new System.EventHandler(this.cbUnicode_CheckedChanged);
            // 
            // timer1
            // 
            this.timer1.Interval = 1000;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(756, 576);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.cbValueType);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.cbScanType);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.tbValue2);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.tbValue1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnNextScan);
            this.Controls.Add(this.btnFirstScan);
            this.Controls.Add(this.btnNewScan);
            this.Controls.Add(this.lvScanner);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "Main";
            this.Text = "cheatengine-library for c# : Scanner example";
            this.Load += new System.EventHandler(this.fmScanner_Load);
            this.panel1.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.ListBox ltBox;
        private System.Windows.Forms.Button btnOpenProcess;
        private System.Windows.Forms.Button btnProcesses;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnUnload;
        private System.Windows.Forms.Button btnLoad;
        private System.Windows.Forms.ListView lvScanner;
        private System.Windows.Forms.ColumnHeader colAddress;
        private System.Windows.Forms.ColumnHeader colValue;
        private System.Windows.Forms.Button btnNewScan;
        private System.Windows.Forms.Button btnFirstScan;
        private System.Windows.Forms.Button btnNextScan;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbValue1;
        private System.Windows.Forms.TextBox tbValue2;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox cbScanType;
        private System.Windows.Forms.ComboBox cbValueType;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox tbEndScan;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox tbStartScan;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.CheckBox cbCopyOnWrite;
        private System.Windows.Forms.CheckBox cbExecutable;
        private System.Windows.Forms.CheckBox cbWritable;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.CheckBox cbFastScan;
        private System.Windows.Forms.CheckBox cbCase;
        private System.Windows.Forms.CheckBox cbUnicode;
        private System.Windows.Forms.TextBox tbAlignment;
        private System.Windows.Forms.RadioButton rbLastDigits;
        private System.Windows.Forms.RadioButton rbAlignment;
        private System.Windows.Forms.Timer timer1;


    }
}

