namespace Assembler
{
    partial class fmSample
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.ltBox = new System.Windows.Forms.ListBox();
            this.btnOpenProcess = new System.Windows.Forms.Button();
            this.btnProcesses = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnUnload = new System.Windows.Forms.Button();
            this.btnLoad = new System.Windows.Forms.Button();
            this.tbScript = new System.Windows.Forms.RichTextBox();
            this.btnInject = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.ltBox);
            this.panel1.Controls.Add(this.btnOpenProcess);
            this.panel1.Controls.Add(this.btnProcesses);
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel1.Location = new System.Drawing.Point(380, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(246, 410);
            this.panel1.TabIndex = 3;
            // 
            // ltBox
            // 
            this.ltBox.AccessibleName = "";
            this.ltBox.Location = new System.Drawing.Point(16, 183);
            this.ltBox.Name = "ltBox";
            this.ltBox.Size = new System.Drawing.Size(218, 225);
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
            // tbScript
            // 
            this.tbScript.Location = new System.Drawing.Point(33, 69);
            this.tbScript.Name = "tbScript";
            this.tbScript.Size = new System.Drawing.Size(312, 329);
            this.tbScript.TabIndex = 4;
            this.tbScript.Text = "Put your asm script here !";
            // 
            // btnInject
            // 
            this.btnInject.Cursor = System.Windows.Forms.Cursors.Default;
            this.btnInject.Location = new System.Drawing.Point(132, 31);
            this.btnInject.Name = "btnInject";
            this.btnInject.Size = new System.Drawing.Size(117, 23);
            this.btnInject.TabIndex = 5;
            this.btnInject.Text = "Inject this script !";
            this.btnInject.UseVisualStyleBackColor = true;
            this.btnInject.Click += new System.EventHandler(this.btnInject_Click);
            // 
            // fmSample
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(626, 410);
            this.Controls.Add(this.btnInject);
            this.Controls.Add(this.tbScript);
            this.Controls.Add(this.panel1);
            this.Name = "fmSample";
            this.Text = "Cheat Engine Library for c#";
            this.panel1.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.ListBox ltBox;
        private System.Windows.Forms.Button btnOpenProcess;
        private System.Windows.Forms.Button btnProcesses;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnUnload;
        private System.Windows.Forms.Button btnLoad;
        private System.Windows.Forms.RichTextBox tbScript;
        private System.Windows.Forms.Button btnInject;

    }
}

