# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::Modules::AjaxDynamicFieldAttachment;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get necessary objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get form id
    $Self->{FormID} = $ParamObject->GetParam( Param => 'FormID' );

    if ( !$Self->{FormID} ) {
        return $LayoutObject->FatalError(
            Message => Translatable('Got no FormID.'),
        );
    }

    # challenge token check for write action
    $LayoutObject->ChallengeTokenCheck();

    if ( $Self->{Subaction} eq 'Delete' ) {

        my $Return;
        my $AttachmentFileID   = $ParamObject->GetParam( Param => 'FileID' )   || '';
        my $AttachmentObjectID = $ParamObject->GetParam( Param => 'ObjectID' ) || '';
        my $AttachmentFieldID  = $ParamObject->GetParam( Param => 'FieldID' )  || '';

        if ( !$AttachmentFileID ) {
            $Return->{Message} = $LayoutObject->{LanguageObject}->Translate(
                'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).'
            );
        }
        else {

            my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                ID => $AttachmentFieldID,
            );

            if ( IsHashRefWithData($DynamicFieldConfig) ) {

                # remove file from upload cache
                $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $AttachmentFileID,
                );

                # fetch values
                my $Value = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $AttachmentObjectID,
                );

                if ( IsArrayRefWithData($Value) ) {

                    # check if index is present ( matching $Value->[$AttachmentFileID - 1] )
                    my $FileData = $Value->[ $AttachmentFileID - 1 ];
                    if ( IsHashRefWithData($FileData) ) {

                        # we verified file validity as far as possible, now remove file from upload cache
                        $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDRemoveFile(
                            FormID => $Self->{FormID},
                            FileID => $AttachmentFileID,
                        );

                        # return remaining files to display them correctly
                        splice $Value->@*, $AttachmentFileID - 1, 1;

                        # return remaining files
                        $Return = {
                            Message => Translatable('Success'),
                            Data    => $Value,
                        };
                    }
                    else {
                        $Return->{Message} = $LayoutObject->{LanguageObject}->Translate(
                            'Error: the file could not be deleted properly. Please contact your administrator (missing file data).'
                        );
                    }
                }
                else {
                    $Return->{Message} = $LayoutObject->{LanguageObject}->Translate(
                        'Error: the file could not be deleted properly. Please contact your administrator (no files stored).'
                    );
                }
            }
            else {
                $Return->{Message} = $LayoutObject->{LanguageObject}->Translate(
                    'Error: the file could not be deleted properly. Please contact your administrator (missing config for dynamic field).'
                );
            }
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => $Return,
            ),
            Type    => 'inline',
            NoCache => 1,
        );
    }
}

1;
