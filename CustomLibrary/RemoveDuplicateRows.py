import pandas as pd
from robot.api.deco import keyword, library

@library(scope='GLOBAL')
class RemoveDuplicateRows:

    @keyword
    def remove_duplicate_rows(self, file_path, columns=None, sheet_name=None, output_path=None, sort=True):
        """
        Remove duplicate rows from an Excel file based on given columns.
        Optionally sort the rows based on those columns.

        Arguments:
        - file_path: Full path to the Excel file.
        - columns: List of column names (Robot list or comma-separated string) to check duplicates & optionally sort.
        - sheet_name: (Optional) Name of the sheet. If None, uses the first sheet.
        - output_path: (Optional) Where to save the cleaned file. Defaults to original file.
        - sort: (Optional) Whether to sort rows by the provided columns. Default is True.
        """

        if sheet_name:
            df = pd.read_excel(file_path, sheet_name=sheet_name)
        else:
            df = pd.read_excel(file_path, sheet_name=0)

        # Normalize column input
        if columns:
            if isinstance(columns, str):
                columns = [col.strip() for col in columns.split(",")]
            elif isinstance(columns, list):
                columns = list(columns)

        # Drop duplicates
        df = df.drop_duplicates(subset=columns, keep='first') if columns else df.drop_duplicates()

        # Optional sorting
        if sort and columns:
            df = df.sort_values(by=columns)

        # Save
        save_path = output_path if output_path else file_path
        df.to_excel(save_path, index=False)
