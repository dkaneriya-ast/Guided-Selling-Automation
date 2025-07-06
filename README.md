<h1 align="center" id="title">Guided Selling Automation</h1>

<p id="description">
This project automates the testing of the Guided Selling Flow on the Afterall platform using Robot Framework and Selenium.  
Its primary objective is to verify that all relevant data is correctly replicated across all locations, based on various combinations of dispositions and service methods.
</p>

<h2>🛠️ Installation Steps:</h2>

<p>1. Ensure you have Python installed on your machine.</p>

<p>2. Setup your Project</p>

```
git clone https://github.com/dkaneriya-ast/Guided-Selling-Automation
```

<p>3. Navigate to the project directory</p>

```
cd Guided-Selling-Automation
```

<p>4. Create a new venv in your project root</p> (Do not use <> in the console)

```
python3 -m venv <myenvname> OR python -m venv <venv> 
```

<p>5. Activate the venv </p>

```
venv/Scripts/Activate.ps1
```

<p>6. Run the command below in the project root of the virtual environment (venv) to install all required libraries and dependencies</p>

```
pip install -r requirements.txt
```

<h2>Instructions</h2>

<ol>
  <li>
    Prepare the test data by uploading an Excel file in the required format.
    A sample file named <code>locations.xlsx</code> is already available in the <code>Data</code> folder.
    <ul>
      <li>Only the <strong>second column</strong> (URL) needs to be filled in manually.</li>
      <li>The <strong>first</strong> and <strong>third</strong> columns already contain formulas and should not be modified.</li>
      <li>This Excel file is used to drive data for the test suite using a data-driven approach via the <code>DataDriver</code> library.</li>
    </ul>
  </li>

  <li>
    The framework uses <strong>parallel test execution</strong> via <code>pabot</code> to speed up the testing process.
    <ul>
      <li>All test results are collected in runtime memory using Robot Framework’s parallel-safe variables.</li>
      <li>Once all parallel processes finish execution, a results file is automatically generated as <code>results.xlsx</code> in the <code>Results</code> folder.</li>
    </ul>
  </li>

  <li>
    To run the tests, use the following command:
    <pre><code>pabot --processes 4 --testlevelsplit --outputdir Results Tests/GuidedSellingFlow.robot</code></pre>
    <ul>
      <li><code>--processes</code>: Number of parallel test runners to use. You can adjust this value based on your system’s core count (e.g., 2, 4, 6, 8).</li>
      <li><code>--testlevelsplit</code>: Ensures each test case is split and run independently across processes.</li>
      <li><code>--outputdir</code>: Directory where log files and the generated Excel result file will be stored.</li>
    </ul>
  </li>

  <li>
    <strong>Recommended:</strong> Install the 
    <a href="https://marketplace.visualstudio.com/items?itemName=d-biehl.robotcode" target="_blank">
      Robot Framework Language Server extension for VS Code
    </a>
    for enhanced editing support including syntax highlighting, autocomplete, and test explorer integration.
  </li>
</ol>