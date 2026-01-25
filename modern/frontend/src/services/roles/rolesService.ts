import httpClient from '@/services/api/http-client';
import type {
  GetRolePermissionResponse,
  UpdatePermissionArgs,
  UpdatePermissionResponse,
  GetRolesArgs,
  GetRolesResponse,
  GetPermissionListResponse,
} from '@/services/roles/types';

const baseRoute = '/RolePermission';

export const getRoles = async (payload: GetRolesArgs): Promise<GetRolesResponse> => {
  const response = await httpClient.post<GetRolesResponse>(`${baseRoute}/GetRoles`, payload);
  return response.data;
};

export const getRolePermissionById = async (roleId: string): Promise<GetRolePermissionResponse> => {
  const response = await httpClient.get<GetRolePermissionResponse>(
    `${baseRoute}/GetModulePermissionsByRole`,
    {
      params: { roleId },
    }
  );
  return response.data;
};

export const getRolePermission = async (): Promise<GetPermissionListResponse> => {
  const response = await httpClient.get<GetPermissionListResponse>(
    `${baseRoute}/GetPermissionList`
  );
  return response.data;
};

export const updatePermission = async (
  args: UpdatePermissionArgs
): Promise<UpdatePermissionResponse> => {
  const response = await httpClient.post<UpdatePermissionResponse>(
    `${baseRoute}/SaveRolePermissions`,
    args
  );
  return response.data;
};
