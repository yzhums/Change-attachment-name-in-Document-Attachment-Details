page 50110 "Rename Dialog"
{
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(AttachmentTableID; AttachmentTableID)
                {
                    ApplicationArea = All;
                    Caption = 'Table ID';
                    Editable = false;
                }
                field(AttachmentNo; AttachmentNo)
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                }
                field(FileName; FileName)
                {
                    ApplicationArea = All;
                    Caption = 'File Name';
                    Editable = false;
                }
                field(ChangeFileName; ChangeFileName)
                {
                    ApplicationArea = All;
                    Caption = 'New File Name';
                }
            }
        }
    }

    var
        FileName: Text[250];
        ChangeFileName: Text[250];

        AttachmentTableID: Integer;
        AttachmentNo: Code[20];
        AttachmentDocumentType: Enum "Attachment Document Type";
        AttachmentLineNo: Integer;
        AttachmentID: Integer;

    procedure AssignValues(NewFileName: Text[250]; NewAttachmentTableID: Integer; NewAttachmentNo: Code[20]; NewAttachmentDocumentType: Enum "Attachment Document Type"; NewAttachmentLineNo: Integer; NewAttachmentID: Integer)
    begin
        InitialValues();
        FileName := NewFileName;
        AttachmentTableID := NewAttachmentTableID;
        AttachmentNo := NewAttachmentNo;
        AttachmentDocumentType := NewAttachmentDocumentType;
        AttachmentLineNo := NewAttachmentLineNo;
        AttachmentID := NewAttachmentID;
    end;

    procedure ChangeAttachmentFileName()
    var
        DocumentAttachment: Record "Document Attachment";
    begin
        if DocumentAttachment.Get(AttachmentTableID, AttachmentNo, AttachmentDocumentType, AttachmentLineNo, AttachmentID) then begin
            DocumentAttachment.Validate("File Name", ChangeFileName);
            DocumentAttachment.Modify(true);

        end;
    end;

    local procedure InitialValues()
    begin
        FileName := '';
        ChangeFileName := '';
        AttachmentTableID := 0;
        AttachmentNo := '';
        AttachmentDocumentType := AttachmentDocumentType::Quote;
        AttachmentLineNo := 0;
        AttachmentID := 0;
    end;
}

pageextension 50110 DocumentAttachmentDetailsExt extends "Document Attachment Details"
{
    actions
    {
        addafter(Preview)
        {
            action(ChangeFileName)
            {
                Caption = 'Change File Name';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Change;

                trigger OnAction()
                var
                    RenameDialog: Page "Rename Dialog";
                begin
                    RenameDialog.AssignValues(Rec."File Name", Rec."Table ID", Rec."No.", Rec."Document Type", Rec."Line No.", Rec.ID);
                    if RenameDialog.RunModal() = Action::OK then
                        RenameDialog.ChangeAttachmentFileName();
                end;
            }
        }
    }
}
