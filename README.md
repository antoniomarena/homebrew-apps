# Table of Contents

- [EF Portal Client](#ef-portal-client)
- [Why Use EF Portal Client?](#why-use-ef-portal-client)
  - [Key Benefits](#key-benefits)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Enable Shell Completion](#enable-shell-completion)
  - [Verify Shell Completion](#verify-shell-completion)
- [Authentication](#authentication)
- [Configuration](#configuration)
  - [Example: Overriding Configuration Parameters](#example-overriding-configuration-parameters)
  - [Command Line](#command-line)
  - [Environment Variables](#environment-variables)
  - [Configuration File](#configuration-file)
    - [Example Format](#example-format)
- [Usage](#usage)
  - [Common Examples](#common-examples)
    - [Create a New Authentication Token](#create-a-new-authentication-token)
    - [Get All Jobs on the Default HPC Scheduler or VDI Session Manager](#get-all-jobs-on-the-default-hpc-scheduler-or-vdi-session-manager)
    - [Get Info for Job with _id_ `11`](#get-info-for-job-with-id-11)
    - [List All Services Available in the EF Portal Technology Showcase](#list-all-services-available-in-the-ef-portal-technology-showcase)
    - [Describe a Service Available in the EF Portal Technology Showcase](#describe-a-service-available-in-the-ef-portal-technology-showcase)
    - [Submit the `job.submission` Service Using Local File $HOME/file.txt and Compression Level 4](#submit-the-jobsubmission-service-using-local-file-homefiletxt-and-compression-level-4)
    - [List Files in Spooler after `job.submission` Service Submission](#list-files-in-spooler-after-jobsubmission-service-submission)
    - [Download a File from the Spooler](#download-a-file-from-the-spooler)
    - [Upload a File into the Spooler](#upload-a-file-into-the-spooler)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## EF Portal Client

[![linting: pylint](https://img.shields.io/badge/linting-pylint-yellowgreen)](https://github.com/pylint-dev/pylint)

EF Portal Client is an easy-to-use and lightweight Python client to interact with the EF Portal REST API. It offers:

- Full support of all available EF Portal REST endpoints.
- Support for Linux, Mac, and Windows platforms.
- Feature parity with legacy `efclient/efsubmit` Web Service clients.
- Full support of the legacy `.efclient.conf` file.
- Flexible configuration using command-line options, environment variables, or configuration files.
- JSON output, with plaintext output offered to ease command-line only usage.
- Shell autocompletion on Linux and Mac.
- Seamless HTTPS connections.

## Why Use EF Portal Client?

Whether you are managing HPC jobs or interacting with EF services, this client simplifies your workflow by providing seamless integration with EF Portal's REST API.

### Key Benefits

- Automate job submission to your HPC cluster with just a few commands.
- Manage configurations flexibly using environment variables, command-line options, or configuration files.
- Access all EF Portal REST API endpoints through a lightweight Python client.

## Installation

### Prerequisites

- `brew` package manager
- Python 3.13 or later.
- `EF Portal 2025.0` or higher on your server; if your version is below `2025.0`, contact your system administrator to update the server.

```bash
brew tap nisp/apps
brew install efpclient
```

After installation, verify it works by running:

```bash
efpclient --version
```

You should see something like this:

```shell
NI SP Software EF Portal Client, version 2025.0.4
```

### Enable Shell Completion

To enable shell completion, register a special function with your shell. The built-in shells are `bash`, `zsh`, and `fish`. Once enabled, you can use the `Tab` key to autocomplete commands.

Follow these steps based on your shell:

**Bash**: Add this to `~/.bashrc`

```bash
eval "$(_EFPCLIENT_COMPLETE=bash_source efpclient)"
```

Then reload your shell:

```bash
source ~/.bashrc
```

**Zsh**: Add this to `~/.zshrc`

```shell
eval "$(_EFPCLIENT_COMPLETE=zsh_source efpclient)"
```

Reload your shell:

```shell
source ~/.zshrc
```

**Fish**: Add this to `~/.config/fish/completions/foo-bar.fish`

```shell
_EFPCLIENT_COMPLETE=fish_source efpclient | source
```

### Verify Shell Completion

Test shell completion by typing:

```bash
efpclient <Tab>
```

If enabled correctly, you should see a list of available commands.

## Authentication

EF Portal REST endpoints only support token-based authentication. You must either save a token in your configuration file or export it as an environment variable.

Here is an example of exporting a token as an environment variable on a BASH shell:

```bash
export EFP_CLIENT_TOKEN=$(efpclient token create --token-only)
```

> 💡 **Key Command:**
> Use the `efpclient token create` command to generate a new authentication token. Ensure you have configured your username and password beforehand.

## Configuration

EF Portal Client finds its configuration parameters from different sources, using a priority mechanism.

- Command line (highest priority)
- Environment variables
- Configuration file (lowest priority)

### Example: Overriding Configuration Parameters

```yaml
url = https://myportal.mycompany.com/efportal
```

You can override it using:

- Command-line option

```bash
efpclient --url https://newportal.mycompany.com/efportal jobs all
```

- Environment variable

```bash
export EFP_CLIENT_PORTAL_URL=https://newportal.mycompany.com/efportal

efpclient jobs all
```

### Command Line

Use the `--help` parameter on `efpclient` itself as well as any available command to get help on available configuration parameters, e.g.:

```bash
efpclient --help

efpclient jobs info --help
```

### Environment Variables

Following environment variables are available:

| Variable name            | Description                                                                                         |
|--------------------------|-----------------------------------------------------------------------------------------------------|
| EFP_CLIENT_PORTAL_URL    | EF Portal base URL in the form `http(s)://<host>:<port>/context`                                    |
| EFP_CLIENT_SDF           | Default Service Definition File (SDF) used when interacting with services                           |
| EFP_CLIENT_AUTH_USERNAME | Username to get a new authentication token                                                          |
| EFP_CLIENT_AUTH_PASSWORD | Password to get a new authentication token                                                          |
| EFP_CLIENT_TOKEN         | Authentication token used to interact with the EF Portal REST API                                   |
| EFP_CLIENT_SSL_VERIFY    | Set to 'true' to enable SSL certificates verification                                               |
| EFP_CLIENT_CA_BUNDLE     | CA certificate bundle file to use when SSL certificates verification is enabled                     |
| EFP_CLIENT_LOG_LEVEL     | Set the log level. Possible values are: `debug`, `info`, `warn`, `error`, `none`. Default is `warn` |

### Configuration File

The configuration file allows you to define default settings for EF Portal Client. It is located at `<user.home>/.efpclient.conf`. If it’s missing, it will be automatically created the first time you run the client.

The `efclient/efsubmit` legacy configuration file is fully supported and will be used if found in `<user.home>/.efclient.conf`. In this case, the new configuration file will not be created automatically.

If both `.efpclient.conf` and `.efclient.conf` are available, the new configuration file will have highest priority. Usage of the new configuration file format is strongly suggested since it adds more flexibility.

> 💡 **Tip:** If you are migrating from legacy `efclient/efsubmit`, ensure that your `.efclient.conf` file is located in `<user.home>` so it can be detected automatically.

Open the file to view or edit supported parameters. The next section has an example configuration file.

#### Example Format

EF Portal Client uses a basic Python configuration format. Below is an example of a complete `.efpclient.conf` file:

```yaml
[output]
# Set the log level. Default is warn.
# Possible values are: debug, info, warn, error, none
log-level = info

[authentication]
# Username used to authenticate while getting a new token.
username = johndoe

# Password used to authenticate while getting a new token.
password = my_super_strong_password

# Enable HTTP Basic Authentication to authenticate while getting a new token.
# This is needed if EF Portal is configured with HTTP authority
# and running behind a web server which uses HTTP Basic Authentication scheme.
# http-basic-auth = true

# Token used to authenticate the client when calling the REST endpoints.
token = aabbccddeeffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz

[security]
# Enable SSL certificates verification.
ssl-verify = true

# CA certificate bundle to use when SSL certificates verification is enabled.
ca-bundle = /path/to/ca-bundle.pem

[portal]
# EF Portal base URL in the form http(s)://<host>:<port>/context
# e.g. https://ef-portal.com:8443/efportal
# No need to specify default 80 or 443 ports.
url = https://mycompany.com/efportal

# Default Service Definition File (SDF) URI used when interacting with services.
# This can be specified each time on the command line as an option.
# e.g. /plugin_name/sdf.xml
sdf = /vdi/vdi.xml
```

Modify this file based on your specific requirements.

## Usage

The general syntax of `efpclient` is as follows:

```bash
efpclient [global_options] COMMAND_GROUP COMMAND [command_options]
```

You can use `--help` on any section to get the respective help.

A valid authentication token needs to be configured before performing any action available.

### Common Examples

Examples below assume a valid portal URL configured either in the configuration file or in the `EFP_CLIENT_PORTAL_URL` environment variable. Alternatively, you can use the `--url` command line parameter.

#### Create a New Authentication Token

Generate a new token and set it as an environment variable:

```bash
export EFP_CLIENT_TOKEN=$(efpclient token create --token-only)
```

#### Get All Jobs on the Default HPC Scheduler or VDI Session Manager

```bash
efpclient jobs all
```

#### Get Info for Job with _id_ `11`

```bash
efpclient jobs info --id 11
```

This is what the output looks like for that command:

```bash
▶ efpclient jobs info --id 11
{
    "manager": "slurm",
    "id": "11",
    "name": "Batch_Service",
    "owner": "efadmin",
    "queue": "batch",
    "total_cpu_usage": "0:00",
    "memory_usage": "2000M",
    "swap_usage": "0",
    "execution_hosts": "efpjammy",
    "submission_time": "2025-02-28T21:05:59",
    "execution_time": "2025-02-28T21:05:59",
    "execution_directory": "/mnt/nisp/efportal/spoolers/efadmin/tmp11506891577044139719.ef",
    "nice": "0",
    "reasons": [
        {
            "value": "None"
        }
    ],
    "status": {
        "ef": "Done",
        "grid": "COMPLETED",
        "value": "DONE"
    }
}
```

#### List All Services Available in the EF Portal Technology Showcase

```bash
efpclient services list --sdf /demo/showcase/showcase.xml
```

> 💡 **Tip:**
> You can configure the SDF URI either in the configuration file or in the `EFP_CLIENT_SDF` environment variable

Following examples will assume the above SDF URI is configured.

#### Describe a Service Available in the EF Portal Technology Showcase

```bash
efpclient services describe --service //showcase/job.submission
```

This is what the output looks like for that command:

```bash
▶ efpclient services describe --service //showcase/job.submission
{
    "id": "job.submission",
    "uri": "//showcase/job.submission",
    "name": "Simple Job Submission",
    "options": [
        {
            "id": "file",
            "label": "File to compress: ",
            "type": "file",
            "option": "--opt-file FILENAME",
            "help": "File to compress: . Specify a single local file to upload."
        },
        {
            "id": "level",
            "label": "Compression level: ",
            "type": "list",
            "value": "9",
            "choices": [
                {
                    "value": "9",
                    "label": "maximum"
                },
                {
                    "value": "4",
                    "label": "medium"
                },
                {
                    "value": "1",
                    "label": "minimum"
                }
            ],
            "option": "--opt-level VALUE_1|VALUE_2|...",
            "help": "Compression level: . Default value is: 9. Valid values to choose from are: 9, 4, 1"
        },
        {
            "id": "scheduler",
            "label": "Job scheduler: ",
            "type": "list",
            "choices": [
                {
                    "label": "- auto -"
                },
                {
                    "value": "slurm",
                    "label": "slurm"
                }
            ],
            "option": "--opt-scheduler VALUE_1|VALUE_2|...",
            "help": "Job scheduler: . Valid values to choose from are: slurm"
        }
    ],
    "actions": [
        {
            "id": "submit",
            "result": "text/xml"
        }
    ]
}
```

> 💡 **Tip:**
> You can get a command line friendly help for available service options using:

```bash
efpclient services submit --service //showcase/job.submission --help
```

This is what the output looks like for that command:

```bash
▶ efpclient services submit --service //showcase/job.submission --help
Usage: efpclient services submit [OPTIONS] [SUBMIT_OPTIONS]...

  Submit a service given its URI and options

Options:
  -d, --sdf TEXT      URI of the SDF containing the service to describe, e.g.
                      /plugin_name/sdf.xml
  -s, --service TEXT  URI of the service to describe, e.g.
                      //sdf_name/service_name
  -h, --help          Show this message and exit.

Service options:
  --opt-file FILENAME
      File to compress:
      Specify a single local file to upload.
  --opt-level VALUE_1|VALUE_2|...
      Compression level:
      Default value is: 9
      Valid values to choose from are (description in quotes):
      - 9   "maximum"
      - 4   "medium"
      - 1   "minimum"
  --opt-scheduler VALUE_1|VALUE_2|...
      Job scheduler:
      Valid values to choose from are (description in quotes):
      - slurm   "slurm"
```

#### Submit the `job.submission` Service Using Local File $HOME/file.txt and Compression Level 4

```bash
efpclient services submit --service //showcase/job.submission --opt-file $HOME/file.txt --opt-level 4
```

This is what the output looks like for that command:

```bash
{
    "uri": "spooler:///opt/nisp/efportal/spoolers/efadmin/tmp5684536515238930625.ef",
    "output": "/efportal/rest/system/services?_uri=//com.enginframe.system/show.spooler&_spooler=spooler%3A%2F%2F%2Fopt%2Fnisp%2Fefportal%2Fspoolers%2Fefadmin%2Ftmp5684536515238930625.ef"
}
```

#### List Files in Spooler after `job.submission` Service Submission

```bash
efpclient spoolers files --uri spooler:///opt/nisp/efportal/spoolers/efadmin/tmp5684536515238930625.ef
```

This is what the output looks like for that command:

```bash
[
    {
        "path": "/",
        "vroot": "5d92da4ac796d64ff93eae3116652dd7934567d3",
        "name": "file.txt.gz",
        "type": "file",
        "modified": "2025-03-18T14:13:00+00:00",
        "url": "https://demo:8448/efportal/download?file=/5d92da4ac796d64ff93eae3116652dd7934567d3//file.txt.gz&_spooler=spooler:///mnt/nisp/efportal/spoolers/efadmin/tmp5684536515238930625.ef&_size=56&_plugin=fm",
        "size": {
            "value": 56,
            "unit": "bytes"
        }
    },
    {
        "path": "/",
        "vroot": "5d92da4ac796d64ff93eae3116652dd7934567d3",
        "name": "slurm-106.out",
        "type": "file",
        "modified": "2025-03-18T14:21:00+00:00",
        "url": "https://demo:8448/efportal/download?file=/5d92da4ac796d64ff93eae3116652dd7934567d3//slurm-106.out&_spooler=spooler:///opt/nisp/efportal/spoolers/efadmin/tmp5684536515238930625.ef&_size=0&_plugin=fm",
        "size": {
            "value": 0,
            "unit": "bytes"
        }
    }
]
```

#### Download a File from the Spooler

```bash
efpclient spoolers download --uri spooler:///opt/nisp/efportal/spoolers/efadmin/tmp5684536515238930625.ef --filename file.txt.gz
```

#### Upload a File into the Spooler

```bash
efpclient spoolers upload --uri spooler:///opt/nisp/efportal/spoolers/efadmin/tmp5684536515238930625.ef --file $HOME/anotherfile.txt
```

> 💡 **Tip:**
> You can use `--file` multiple times to upload more than one file at once

## Troubleshooting

### Issue: Command not found after installation

Ensure that the Python installation directory is in your system's PATH. You can check this by running:

```bash
echo $PATH
```

If it’s missing, add it to your PATH variable. For example:

```bash
export PATH=$PATH:/path/to/python/bin
```

### Issue: Invalid authentication token

Verify that you have exported a valid token using:

```bash
export EFP_CLIENT_TOKEN=$(efpclient token create --token-only)
```

### Issue: Shell completion not working

Double-check that you've added the correct lines to your shell configuration file (`~/.bashrc`, `~/.zshrc`, or `~/.config/fish/completions/`). Reload your shell and test using the `Tab` key.

## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
