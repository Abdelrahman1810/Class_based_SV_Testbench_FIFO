# Class_based_SV_Testbench_FIFO
SV project - Synchronous FIFO

### Simulation Setup
1. To observe the design behavior in the waveform, run the `run.do` script.
2. To extract all the reports, run the `run_extract_report.do` script.

### Configurable Parameters
Before running the simulation, you can modify the following loop variables in the `shared_pkg.sv` file:
- `LOOP0`
- `LOOP1`
- `LOOP2`
- `LOOP3`

## Verification Plane
- Activate reset at the first 5 cycle.
- Apply requirement constraint.
- Write only to make FIFO full.
- Write when FIFO full.
- Read times less than FIFO_DEPTH.
- Apply read and write at the same time.
- Toggle between read and write but (Not both high at the same time).
- Read only to make FIFO empty.
- Read when FIFO empty.
- Write times equal (FIFO_DEPTH-1) to get almostfull.
- Apply read and write at the same time.
- Write only to make FIFO full.
- Read times equal (FIFO_DEPTH-1) to get almostempty.
- Apply read and write at the same time.
- Activate reset.
- Randomization with Constraint read has high probability.
- Randomization with no Constraint.

## Project Structure

The project contains the following components:

1. **Documentation**:
   - `Abdelrhaman_SV_FIFO_report.pdf`: Verification plan, flow, and code descriptions.
   - `FIFO_description.pdf`: Description of the FIFO design.

2. **Codes**:
   - **interface**:
     - `interface.sv`: Interface code.
   - **Design**:
     - `FIFO.v`: Design code.
   - **refrence**:
     - `FIFO_ref.sv`: Reference code.
   - **shared_pkg**:
     - `shared_pkg.sv`: Shared package with all shared variables.
     - `transaction_pkg.sv`: transaction package with all constraint for inputs.
     - `scoreboard_pkg.sv`: scoreboard package to compare DUT out with REF out.
     - `coverage_pkg.sv`: coverage package with all shared variables.
   - **testbench**:
     - `testbench.sv`: testbench code.
     - `ref_tb.sv`: testbench for golden model.
     - `fifoo.dat`: fifo memory to test refrence design.
   - **monitor**:
     - `monitor.sv`: monitor code to send data to scoreboard and sample data and display error and correct counter.
   - **top**:
     - `top.sv`: top code.
    
3. **Reports**:
   - **html_code_cover_report**:
     - `index.html`: Code coverage HTML report
   - **Text Reports**:
     - `code_cover_FIFO.txt`: Code coverage text report
     - `covergroup_report.txt`: covergroup text report
     - `Directive_cover_report.txt`: Directive coverage text report
4. `run.do`: ruv the code and see the waveform
5. `run_extract_report.do`: ruv the code and extract cover reports

## Getting Started
To get started with this repository, follow these steps:
> [!IMPORTANT]
> You need to download [QuestaSim](https://support.sw.siemens.com/en-US/) first.

1. Clone the repository to your local machine using the following command:
```ruby
git clone https://github.com/Abdelrahman1810/Class_based_SV_Testbench_FIFO.git
```
2. Open QuestaSim and navigate to the directory where the repository is cloned.
3. Compile the Verilog files by executing the following command in the QuestaSim transcript tap: 
```ruby
do run.do
```
This will compile All files in Codes folder.

## Contributing
If you find any issues or have suggestions for improvement, feel free to submit a pull request or open an issue in the repository. Contributions are always welcome!

## Contact info 💜

<a href="http://wa.me/201061075354" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/whatsapp-128C7E.svg?style=for-the-badge&logo=whatsapp&logoColor=white" /></a> 

<a href="https://www.linkedin.com/in/abdelrahman-mohammed-814a9022a/" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/linkedin-0077b5.svg?style=for-the-badge&logo=linkedin&logoColor=white" /></a>

Gmail : abdelrahmansalby23@gmail.com 📫

### this project from Eng.Kareem Waseem diploma
  <tbody>
    <tr>
      <td align="left" valign="top" width="14.28%">
      <a href="https://www.linkedin.com/in/kareem-waseem/"><img src="https://media.licdn.com/dms/image/C5603AQGwfgJJNpo8MQ/profile-displayphoto-shrink_800_800/0/1549202493548?e=1721865600&v=beta&t=9azKJacf-SZ18LX4UHwEa4gYKDCTIqLEwEDFWIu19Ko" width="100px;" alt="Kareem Waseem"/><br /><sub><b>Kareem Waseem</b></sub></a>
      <br /><a href="kwaseem94@gmail.com" title="Gmail">📧</a> 
      <a href="https://www.linkedin.com/in/kareem-waseem/" title="LinkedIn">🌍</a>
      <a href="https://linktr.ee/kareemw" title="Talks">📢</a>
      <a href="https://www.facebook.com/groups/319864175836046" title="Facebook grp">💻</a>
      </td>
    </tr>
  </tbody>