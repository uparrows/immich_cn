Immich allows the admin user to set the uploaded filename pattern. Both at the directory and filename level.

The admin user can set the template by using the template builder in the `Administration -> Settings -> Storage Template`. Immich provides a set of variables that you can use in constructing the template, along with additional custom text. If the template produces [multiple files with the same filename, they won't be overwritten](https://github.com/immich-app/immich/discussions/3324) as a sequence number is appended to the filename.

```bash title="Default template"
Year/Year-Month-Day/Filename.Extension
```

<img src={require('./img/storage-template.png').default} width="100%" title="Storage Template Setting" />

Immich also provides a mechanism to migrate between templates so that if the template you set now doesn't work in the future, you can always migrate all the existing files to the new template. The mechanism is run as a job on the Job page.
