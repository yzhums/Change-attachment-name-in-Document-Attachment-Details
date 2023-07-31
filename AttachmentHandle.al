codeunit 50110 AttachmentHandle
{
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnBeforeSaveAttachment, '', false, false)]
    local procedure OnBeforeSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FileName: Text; var TempBlob: Codeunit "Temp Blob");
    var
        ExtensionName: Text[250];
        FileNameWithoutExtension: Text[30];
        FileManagement: Codeunit "File Management";
    begin
        if FileName <> '' then begin
            FileNameWithoutExtension := '';
            ExtensionName := '';
            FileNameWithoutExtension := FileManagement.GetFileNameWithoutExtension(FileName);
            ExtensionName := FileManagement.GetExtension(FileName);
            FileNameWithoutExtension := FileNameWithoutExtension + '_' + Format(Today, 0, '<Day,2>-<Month,2>-<Year>');
            FileName := FileManagement.CreateFileNameWithExtension(FileNameWithoutExtension, ExtensionName);
        end;
    end;
}
